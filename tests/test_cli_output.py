"""Conversion failures must not destroy input or existing output files."""

from pathlib import Path

import pytest
from typer.testing import CliRunner

from mdtyp.cli import app


@pytest.mark.parametrize("alias", ["same", "symlink", "hardlink"])
@pytest.mark.parametrize("latex", [False, True])
def test_output_cannot_alias_input(tmp_path, alias, latex):
    source = tmp_path / "notes.md"
    original = "# Keep this Markdown\n"
    source.write_text(original)
    dest = source if alias == "same" else tmp_path / "output.typ"
    if alias == "symlink":
        dest.symlink_to(source)
    elif alias == "hardlink":
        dest.hardlink_to(source)
    args = [str(source), "-o", str(dest)] + (["--latex"] if latex else [])
    result = CliRunner().invoke(app, args)
    assert result.exit_code != 0
    assert source.read_text() == original
    assert dest.read_text() == original


def test_pdf_collision_is_rejected_before_writing_typst(tmp_path):
    source = tmp_path / "notes.md"
    source.write_text("# Original\n")
    dest = tmp_path / "output.typ"
    dest.write_text("Existing Typst")
    dest.with_suffix(".pdf").symlink_to(source)
    result = CliRunner().invoke(app, [str(source), "-o", str(dest), "--pdf"])
    assert result.exit_code != 0
    assert source.read_text() == "# Original\n"
    assert dest.read_text() == "Existing Typst"


def test_batch_cannot_overwrite_another_source(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    Path("a.md").write_text("# First\n")
    Path("b.md").write_text("# Second\n")
    Path("a.typ").symlink_to("b.md")
    result = CliRunner().invoke(app, ["--all"])
    assert result.exit_code != 0
    assert Path("b.md").read_text() == "# Second\n"


def test_math_conversion_failure_leaves_existing_output(tmp_path):
    source = tmp_path / "notes.md"
    source.write_text(r"$\sinewave$")
    dest = source.with_suffix(".typ")
    dest.write_text("Previous valid output")
    result = CliRunner().invoke(app, [str(source)])
    assert result.exit_code != 0
    assert "\\sinewave" in result.output
    assert dest.read_text() == "Previous valid output"
