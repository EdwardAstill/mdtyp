# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`mdtyp` is a Python CLI tool that converts Markdown documents to [Typst](https://typst.app/) format. It uses `markdown-it-py` to parse Markdown into a token stream and then renders each token type into the corresponding Typst syntax. LaTeX math expressions (via `$...$` and `$$...$$`) are translated to Typst math syntax.

## Setup & Commands

This project uses [uv](https://docs.astral.sh/uv/) for dependency management. Requires Python >=3.14.

```bash
# Install dependencies and create virtualenv
uv sync

# Run the CLI
uv run mdtyp input.md                  # writes input.typ
uv run mdtyp input.md -o output.typ    # explicit output path
uv run mdtyp input.md --stdout         # print to stdout
echo "# Hello" | uv run mdtyp          # read from stdin
uv run mdtyp --all                     # convert all .md files in cwd

# Run tests
uv run pytest tests/ -v

# Quick smoke test
uv run python -c "from mdtyp.converter import convert; print(convert('# Hello'))"
```

## Architecture

Six modules across two conversion stages, plus config and CLI:

### Markdown → Typst conversion

1. **`mdtyp/converter.py`** — Slim entry point. Parses Markdown with `markdown-it-py` (with `dollarmath` and `strikethrough` plugins), creates a `Ctx`, and dispatches to `render_tokens()`.

2. **`mdtyp/ctx.py`** — `Ctx` class: holds the token stream, output accumulator, config, and list nesting state. Provides `current()`, `peek()`, `advance()`, `has_more()`, `write()`, and `sub_context()` for recursive rendering (blockquotes).

3. **`mdtyp/handlers.py`** — Block-level token handlers. Each handler is a function `(Ctx) -> None` registered in the `BLOCK_HANDLERS` dict. The main `render_tokens()` loop dispatches by token type. Adding a new block token = writing one handler function and adding one dict entry.

4. **`mdtyp/inline.py`** — Inline token rendering. Same registry pattern via `_INLINE_HANDLERS`. Exports `render_inline()` and `escape_typst()`. Wrapping tokens (bold, italic, strikethrough, links) use `_collect_until()` to gather inner tokens.

### LaTeX math → Typst math

5. **`mdtyp/latex2typst.py`** — `latex_to_typst()` applies transformations in a strict pipeline order (each stage assumes prior stages have already run):
   1. **Environments** (`\begin{aligned}`, matrices, cases)
   2. **Structured commands** (`\frac`, `\sqrt`, accents, font commands, `\mathbb`)
   3. **Simple symbol replacements** (`_COMMANDS` list via `_COMPILED_COMMANDS`, precompiled and sorted longest-first)
   4. **Script conversion** (`_{...}` → `_(...)`, `^{...}` → `^(...)`)
   5. **Multi-character identifier quoting** (wraps unknown multi-letter identifiers in `"..."`)
   - `_extract_braced()` is the shared helper for parsing balanced `{}`.
   - `_TYPST_MATH_IDENTS` is the allowlist of identifiers that should NOT be quoted in stage 5.
   - `_replace_with_spacing()` adds spaces around replacements to prevent identifier merging (e.g. `i\pi` → `i pi` not `ipi`).

### Config and CLI

6. **`mdtyp/config.py`** — `Config` dataclass (with nested `TableConfig`, `BlockquoteConfig`, `HrConfig`, `ImageConfig`, `CodeConfig`, `PageConfig`). `load_config(path)` reads TOML; returns defaults if no file exists. Default path: `$XDG_CONFIG_HOME/mdtyp/config.toml`.

7. **`mdtyp/cli.py`** — CLI entry point using Typer. Three code paths (`_convert_all`, `_convert_stdin`, `_convert_file`) share helpers `_convert_source()` and `_emit_to_file()`.

## Key Markdown → Typst Mappings

| Markdown | Typst |
|---|---|
| `# H1` … `###### H6` | `= H1` … `====== H6` |
| `**bold**` | `*bold*` |
| `_italic_` | `_italic_` |
| `~~strike~~` | `#strike[...]` |
| `[text](url)` | `#link("url")[text]` |
| `![alt](src)` | `#figure(image("src"), caption: [alt])` |
| `> quote` | `#quote[...]` (supports nesting) |
| `---` | `#line(length: 100%)` |
| `$...$` / `$$...$$` | `$...$` (with LaTeX→Typst math translation) |
| Tables | `#table(columns: N, ..., table.header(...), ...)` |

## Tests

Tests live in `tests/` using pytest:

- **`test_latex2typst.py`** — Parametrized unit tests for math translation (fractions, Greek, operators, scripts, accents, environments, identifier merging prevention, complex expressions).
- **`test_converter.py`** — Unit tests for the full converter (headings, inline formatting, lists, blockquotes, tables, code, math, config options, special characters).
- **`test_snapshots.py`** — Golden-file test: converts `examples/everything.md` and compares against `examples/everything.typ`. To update after intentional changes: `uv run mdtyp examples/everything.md -o examples/everything.typ`.

## Configuration

Config file at `~/.config/mdtyp/config.toml` (or `$XDG_CONFIG_HOME/mdtyp/config.toml`). Override with `--config`/`-c`. All fields are optional — omitted fields use defaults.

```toml
[table]
header_bold = true     # wrap header cells in *...*
stroke = ""            # e.g. "0.5pt" — adds stroke param to #table

[blockquote]
function = "quote"     # Typst function name for blockquotes

[hr]
style = "#line(length: 100%)"   # exact Typst output for ---

[image]
use_figure = true      # false emits bare #image() without #figure wrapper
width = ""             # e.g. "80%" — adds width param to image()

[code]
block_function = ""    # e.g. "sourcecode" — wraps code blocks in #fn(...)

[page]
paper = ""             # e.g. "a4" — default paper size (CLI --paper overrides)
```
