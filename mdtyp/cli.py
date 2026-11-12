"""CLI entry point for mdtyp."""

import subprocess
import sys
from pathlib import Path
from typing import Optional

import typer

from mdtyp.config import Config, TableStyle, load_config
from mdtyp.converter import convert
from mdtyp.latex import convert_to_latex
from mdtyp.output import write_output

app = typer.Typer(help="Convert Markdown documents to Typst or LaTeX.")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _convert_source(md_text: str, config: Config, latex: bool) -> str:
    """Convert markdown text to the selected output format."""
    if latex:
        return convert_to_latex(md_text)
    try:
        typst_text = convert(md_text, config)
    except ValueError as error:
        typer.echo(f"Conversion failed: {error}", err=True)
        raise typer.Exit(1) from error
    return typst_text


def _emit_to_file(
    output_text: str, dest: Path, pdf: bool, *, sources: tuple[Path, ...] = (),
) -> None:
    """Write rendered text to a file and optionally compile Typst to PDF."""
    try:
        write_output(output_text, dest, sources=sources, pdf=pdf)
    except subprocess.CalledProcessError as error:
        typer.echo(f"typst compile failed:\n{error.stderr}", err=True)
        raise typer.Exit(error.returncode) from error
    except (ValueError, OSError) as error:
        typer.echo(f"Cannot write output: {error}", err=True)
        raise typer.Exit(1) from error
    typer.echo(f"Written to {dest}", err=True)
    if pdf:
        typer.echo(f"Compiled to {dest.with_suffix('.pdf')}", err=True)


def _emit_pdf_to_stdout(typst_text: str) -> None:
    """Compile stdin in the working directory and stream PDF bytes to stdout."""
    try:
        result = subprocess.run(
            ["typst", "compile", "--format", "pdf", "-", "-"],
            input=typst_text.encode("utf-8"), capture_output=True, check=True,
        )
    except subprocess.CalledProcessError as error:
        typer.echo(f"typst compile failed:\n{error.stderr.decode('utf-8', errors='replace')}", err=True)
        raise typer.Exit(error.returncode) from error
    except OSError as error:
        typer.echo(f"Cannot compile PDF: {error}", err=True)
        raise typer.Exit(1) from error
    sys.stdout.buffer.write(result.stdout)


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
        help="Output file. Defaults to <input>.typ or <input>.tex, or stdout when reading stdin.",
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
    margin: Optional[str] = typer.Option(
        None, "--margin",
        help='Typst/PDF page margin, e.g. "15mm" or "1in". Overrides config.',
    ),
    font: Optional[str] = typer.Option(
        None, "--font",
        help="Typst/PDF font family. Overrides config; default: Helvetica, then Arial.",
    ),
    table_style: Optional[TableStyle] = typer.Option(
        None, "--table-style",
        help="Typst/PDF table appearance. Overrides config; default: horizontal.",
    ),
    pdf: bool = typer.Option(
        False, "--pdf",
        help="Compile the generated .typ file to PDF using typst.",
    ),
    latex: bool = typer.Option(
        False, "--latex",
        help="Write LaTeX instead of Typst.",
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
    if latex and (font is not None or table_style is not None or margin is not None):
        raise typer.BadParameter("--font, --table-style, and --margin apply to Typst/PDF, not --latex")
    try:
        config = load_config(config_path)
    except ValueError as error:
        raise typer.BadParameter(f"Invalid configuration: {error}") from error
    if margin is not None:
        if not margin.strip():
            raise typer.BadParameter("--margin must be a non-empty Typst length or margin expression")
        config.page.margin = margin
    if font is not None:
        if not font.strip():
            raise typer.BadParameter("--font must be a non-empty font family name")
        config.text.font = font
    if table_style is not None:
        config.table.style = table_style
    if paper is not None:
        config.page.paper = paper

    if latex and pdf:
        typer.echo("Error: --latex and --pdf are incompatible.", err=True)
        raise typer.Exit(1)

    if all:
        _convert_all(config, pdf, latex)
    elif input is None:
        if sys.stdin.isatty() and not output and not stdout and not latex:
            from mdtyp.tui import MdtypBrowser
            MdtypBrowser(config).run()
            return
        _convert_stdin(config, output, pdf, latex)
    else:
        _convert_file(input, config, output, stdout, pdf, latex)


def _convert_all(config: Config, pdf: bool, latex: bool) -> None:
    md_files = sorted(Path(".").glob("*.md"))
    if not md_files:
        typer.echo("No .md files found in the current directory.", err=True)
        raise typer.Exit(1)
    suffix = ".tex" if latex else ".typ"
    for md_file in md_files:
        output_text = _convert_source(
            md_file.read_text(encoding="utf-8"), config, latex,
        )
        _emit_to_file(output_text, md_file.with_suffix(suffix), pdf, sources=tuple(md_files))


def _convert_stdin(
    config: Config,
    output: Path | None,
    pdf: bool,
    latex: bool,
) -> None:
    if sys.stdin.isatty():
        typer.echo("Reading from stdin… (Ctrl-D to finish)", err=True)
    output_text = _convert_source(sys.stdin.read(), config, latex)
    if output:
        _emit_to_file(output_text, output, pdf)
    elif pdf:
        _emit_pdf_to_stdout(output_text)
    else:
        sys.stdout.write(output_text)


def _convert_file(
    input: Path,
    config: Config,
    output: Path | None,
    to_stdout: bool,
    pdf: bool,
    latex: bool,
) -> None:
    if to_stdout and pdf:
        typer.echo("Error: --stdout and --pdf are incompatible.", err=True)
        raise typer.Exit(1)
    output_text = _convert_source(
        input.read_text(encoding="utf-8"), config, latex,
    )
    if to_stdout:
        sys.stdout.write(output_text)
    else:
        suffix = ".tex" if latex else ".typ"
        _emit_to_file(output_text, output or input.with_suffix(suffix), pdf, sources=(input,))


if __name__ == "__main__":
    app()
