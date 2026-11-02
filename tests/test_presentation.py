"""Presentation defaults, CLI precedence, and rendered table geometry."""

import json
import re
import shutil
import subprocess
import xml.etree.ElementTree as ET

import pytest
from typer.testing import CliRunner

from mdtyp.cli import app


TABLE = """| Item | Quantity | Price |
|:---|---:|---:|
| Apples | 4 | 3.50 |
| Pears | 2 | 2.00 |
| Oranges | 6 | 4.20 |
"""
needs_typst = pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")


def _convert(tmp_path, args):
    source = tmp_path / "document.typ"
    result = CliRunner().invoke(app, ["--stdout", *args], input=TABLE)
    assert result.exit_code == 0, result.output
    source.write_text(result.stdout, encoding="utf-8")
    return source


@needs_typst
@pytest.mark.parametrize("use_config, override, expected", [
    (False, None, "helvetica"),
    (True, None, "arial"),
    (True, "DejaVu Sans", "dejavu sans"),
])
def test_font_default_and_cli_precedence(tmp_path, monkeypatch, use_config, override, expected):
    monkeypatch.setenv("XDG_CONFIG_HOME", str(tmp_path / "empty-config"))
    args = []
    if use_config:
        config = tmp_path / "settings.toml"
        config.write_text('[text]\nfont = "Arial"\n')
        args += ["--config", str(config)]
    if override:
        args += ["--font", override]
    source = _convert(tmp_path, args)
    source.write_text(source.read_text() + "\n#context metadata(text.font)\n")
    result = subprocess.run(
        ["typst", "query", str(source), "metadata", "--field", "value", "--one"],
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    assert json.loads(result.stdout) == expected


@needs_typst
@pytest.mark.parametrize("override, expected_mm", [(None, 25), ("15mm", 15), ("0pt", 0)])
def test_margin_cli_overrides_config(tmp_path, override, expected_mm):
    config = tmp_path / "settings.toml"
    config.write_text('[page]\nmargin = "25mm"\n')
    args = ["--config", str(config)]
    if override is not None:
        args += ["--margin", override]
    source = _convert(tmp_path, args)
    source.write_text(source.read_text() + "\n#context metadata(page.margin / 1mm)\n")
    result = subprocess.run(
        ["typst", "query", str(source), "metadata", "--field", "value", "--one"],
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    assert json.loads(result.stdout) == pytest.approx(expected_mm)


@needs_typst
@pytest.mark.parametrize("style, horizontal, vertical, shaded", [
    (None, 5, 0, False),
    ("horizontal", 5, 0, False),
    ("shaded-horizontal", 0, 0, True),
    ("cell", 5, 4, False),
    ("vertical", 0, 4, False),
])
def test_table_style_draws_the_requested_rules_and_rows(
    tmp_path, monkeypatch, style, horizontal, vertical, shaded,
):
    monkeypatch.setenv("XDG_CONFIG_HOME", str(tmp_path / "empty-config"))
    args = ["--font", "Arial"]
    if style:
        config = tmp_path / "settings.toml"
        # CLI style wins over configuration; stroke width survives that override.
        config.write_text('[table]\nstyle = "cell"\nstroke = "1.25pt"\n')
        args += ["--config", str(config), "--table-style", style]
    source = _convert(tmp_path, args)
    svg = source.with_suffix(".svg")
    result = subprocess.run(["typst", "compile", str(source), str(svg)], capture_output=True, text=True)
    assert result.returncode == 0, result.stderr
    elements = list(ET.parse(svg).getroot().iter())
    rules = [el for el in elements if el.get("stroke") not in (None, "none")]
    assert sum("h" in el.get("d", "").lower() for el in rules) == horizontal
    assert sum("v" in el.get("d", "").lower() for el in rules) == vertical
    assert len(rules) == horizontal + vertical
    if style and not shaded:
        assert {float(el.attrib["stroke-width"]) for el in rules} == {1.25}
    grey = []
    for el in elements:
        fill = el.get("fill", "")
        if re.fullmatch(r"#[0-9a-f]{6}", fill):
            red, green, blue = (int(fill[i:i + 2], 16) for i in (1, 3, 5))
            if 0 < red == green == blue < 255:
                grey.append(el)
    if shaded:
        assert len(grey) == 6  # Three columns across two alternating body rows.
        rows = sorted({float(el.attrib["transform"].split()[1].rstrip(")")) for el in grey})
        height_match = re.search(r"v\s+([0-9.]+)", grey[0].attrib["d"])
        assert height_match is not None
        height = float(height_match[1])
        assert len(rows) == 2
        assert rows[1] - rows[0] == pytest.approx(2 * height)
    else:
        assert grey == []


@pytest.mark.parametrize("args", [
    ["--table-style", "diagonal"], ["--font", " "],
    ["--latex", "--font", "Arial"], ["--latex", "--table-style", "cell"],
    ["--margin", " "], ["--latex", "--margin", "15mm"],
])
def test_invalid_or_inapplicable_flags_leave_output_untouched(tmp_path, args):
    dest = tmp_path / "out.typ"
    dest.write_text("Existing output")
    result = CliRunner().invoke(app, ["-o", str(dest), *args], input=TABLE)
    assert result.exit_code != 0
    assert dest.read_text() == "Existing output"


def test_invalid_config_table_style_is_rejected(tmp_path):
    config = tmp_path / "settings.toml"
    config.write_text('[table]\nstyle = "diagonal"\n')
    result = CliRunner().invoke(app, ["--config", str(config)], input=TABLE)
    assert result.exit_code != 0
    assert "diagonal" in result.output
