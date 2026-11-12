"""Small command smoke checks; rendering is reviewed through the examples."""

import shutil
from pathlib import Path

import pytest
from typer.testing import CliRunner

from mdtyp.cli import app

ROOT = Path(__file__).resolve().parents[1]
EXAMPLE = ROOT / "examples" / "everything.md"


@pytest.fixture(autouse=True)
def isolated_directory(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("XDG_CONFIG_HOME", str(tmp_path / "config"))


@pytest.mark.parametrize("args, output", [
    ([], "notes.typ"),
    (["--latex"], "notes.tex"),
])
def test_file_conversion(args, output):
    original = "# Notes\n\nExample text.\n"
    Path("notes.md").write_text(original)
    result = CliRunner().invoke(app, ["notes.md", *args])
    assert result.exit_code == 0, result.output
    assert Path(output).is_file()
    assert Path("notes.md").read_text() == original


@pytest.mark.parametrize("file_input", [False, True])
def test_stdout(file_input):
    markdown = "# Notes\n\nExample text.\n"
    args = []
    if file_input:
        Path("notes.md").write_text(markdown)
        args = ["notes.md", "--stdout"]
    result = CliRunner().invoke(app, args, input=None if file_input else markdown)
    assert result.exit_code == 0, result.output
    assert "Example text" in result.stdout
    assert not Path("notes.typ").exists()


def test_batch_conversion():
    for name in ("first", "second"):
        Path(f"{name}.md").write_text(f"# {name}\n\n{name} document.\n")
    result = CliRunner().invoke(app, ["--all"])
    assert result.exit_code == 0, result.output
    for name in ("first", "second"):
        assert Path(f"{name}.typ").is_file()


@pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")
@pytest.mark.parametrize("stdin", [False, True])
def test_example_pdf(stdin):
    args = [
        "--pdf", "--config", str(ROOT / "examples2" / "print.toml"),
        "--paper", "a5", "--margin", "15mm",
        "--font", "Libertinus Serif", "--table-style", "shaded-horizontal",
    ]
    if not stdin:
        args = [str(EXAMPLE), *args, "-o", "example.typ"]
    result = CliRunner().invoke(app, args, input=EXAMPLE.read_text() if stdin else None)
    assert result.exit_code == 0, result.stderr
    pdf = result.stdout_bytes if stdin else Path("example.pdf").read_bytes()
    assert pdf.startswith(b"%PDF-")


def test_output_cannot_replace_source():
    source = Path("notes.md")
    source.write_text("# Keep this source\n")
    result = CliRunner().invoke(app, [str(source), "-o", str(source)])
    assert result.exit_code != 0
    assert source.read_text() == "# Keep this source\n"


def test_failed_pdf_keeps_previous_outputs(monkeypatch):
    Path("notes.md").write_text("# Updated notes\n")
    Path("notes.typ").write_text("Previous Typst")
    Path("notes.pdf").write_bytes(b"Previous PDF")
    monkeypatch.setenv("PATH", "")
    result = CliRunner().invoke(app, ["notes.md", "--pdf"])
    assert result.exit_code != 0
    assert Path("notes.typ").read_text() == "Previous Typst"
    assert Path("notes.pdf").read_bytes() == b"Previous PDF"
