"""CLI entry point for mdtyp."""

import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional

import typer

from mdtyp.config import Config, load_config
from mdtyp.converter import convert

app = typer.Typer(help="Convert Markdown documents to Typst.")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _convert_source(md_text: str, config: Config, paper: str | None) -> str:
    """Convert markdown text and optionally prepend page settings."""
    typst_text = convert(md_text, config)
    if paper:
        typst_text = f'#set page(paper: "{paper}")\n\n' + typst_text
    return typst_text


def _emit_to_file(typst_text: str, dest: Path, pdf: bool) -> None:
    """Write typst text to a file and optionally compile to PDF."""
    dest.write_text(typst_text)
    typer.echo(f"Written to {dest}", err=True)
    if pdf:
        _compile_pdf(dest)


def _emit_pdf_to_stdout(typst_text: str) -> None:
    """Compile typst text to PDF and write the PDF bytes to stdout."""
    with tempfile.NamedTemporaryFile(suffix=".typ", delete=False, mode="w") as tmp:
        tmp.write(typst_text)
        tmp_path = Path(tmp.name)
    try:
        _compile_pdf(tmp_path)
        pdf_bytes = tmp_path.with_suffix(".pdf").read_bytes()
        sys.stdout.buffer.write(pdf_bytes)
    finally:
        tmp_path.unlink(missing_ok=True)
        tmp_path.with_suffix(".pdf").unlink(missing_ok=True)


def _compile_pdf(typ_path: Path) -> None:
    """Compile a .typ file to PDF using the typst CLI."""
    try:
        result = subprocess.run(
            ["typst", "compile", str(typ_path)],
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        typer.echo(
            "Error: 'typst' command not found. Install Typst to use --pdf.",
            err=True,
        )
        raise typer.Exit(1)
    if result.returncode != 0:
        typer.echo(f"typst compile failed:\n{result.stderr}", err=True)
        raise typer.Exit(result.returncode)
    typer.echo(f"Compiled to {typ_path.with_suffix('.pdf')}", err=True)


# ---------------------------------------------------------------------------
# Main command
# ---------------------------------------------------------------------------


@app.command()
def mdtyp(
    input: Optional[Path] = typer.Argument(
        None,
        help="Markdown file to convert. Reads from stdin if omitted.",
        exists=True,
        dir_okay=False,
    ),
    output: Optional[Path] = typer.Option(
        None, "--output", "-o",
        help="Output .typ file. Defaults to <input>.typ, or stdout when reading stdin.",
        dir_okay=False,
    ),
    stdout: bool = typer.Option(
        False, "--stdout",
        help="Write to stdout even when an input file is given.",
    ),
    paper: Optional[str] = typer.Option(
        None, "--paper", "-p",
        help='Paper size, e.g. a4, a5, us-letter.',
    ),
    pdf: bool = typer.Option(
        False, "--pdf",
        help="Compile the generated .typ file to PDF using typst.",
    ),
    all: bool = typer.Option(
        False, "--all", "-a",
        help="Convert all .md files in the current directory.",
    ),
    config_path: Optional[Path] = typer.Option(
        None, "--config", "-c",
        help="Path to config TOML file.",
        exists=True,
        dir_okay=False,
    ),
) -> None:
    config = load_config(config_path)
    effective_paper = paper or config.page.paper or None

    if all:
        _convert_all(config, effective_paper, pdf)
    elif input is None:
        _convert_stdin(config, effective_paper, output, pdf)
    else:
        _convert_file(input, config, effective_paper, output, stdout, pdf)


def _convert_all(config: Config, paper: str | None, pdf: bool) -> None:
    md_files = sorted(Path(".").glob("*.md"))
    if not md_files:
        typer.echo("No .md files found in the current directory.", err=True)
        raise typer.Exit(1)
    for md_file in md_files:
        typst_text = _convert_source(md_file.read_text(encoding="utf-8"), config, paper)
        _emit_to_file(typst_text, md_file.with_suffix(".typ"), pdf)


def _convert_stdin(
    config: Config, paper: str | None, output: Path | None, pdf: bool,
) -> None:
    if sys.stdin.isatty():
        typer.echo("Reading from stdin… (Ctrl-D to finish)", err=True)
    typst_text = _convert_source(sys.stdin.read(), config, paper)
    if output:
        _emit_to_file(typst_text, output, pdf)
    elif pdf:
        _emit_pdf_to_stdout(typst_text)
    else:
        sys.stdout.write(typst_text)


def _convert_file(
    input: Path,
    config: Config,
    paper: str | None,
    output: Path | None,
    to_stdout: bool,
    pdf: bool,
) -> None:
    if to_stdout and pdf:
        typer.echo("Error: --stdout and --pdf are incompatible.", err=True)
        raise typer.Exit(1)
    typst_text = _convert_source(input.read_text(encoding="utf-8"), config, paper)
    if to_stdout:
        sys.stdout.write(typst_text)
    else:
        _emit_to_file(typst_text, output or input.with_suffix(".typ"), pdf)


if __name__ == "__main__":
    app()
