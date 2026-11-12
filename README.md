# mdtyp

Convert Markdown documents to [Typst](https://typst.app/) format from the command line, with a built-in interactive file browser.

---

## Installation

Requires Python ≥ 3.14 and [uv](https://docs.astral.sh/uv/).

```bash
uv tool install git+https://github.com/EdwardAstill/mdtyp
```

To compile to PDF (`--pdf` and TUI `p` action), also install [Typst](https://github.com/typst/typst).

---

## Usage

See [the Markdown authoring guide](markdown-guide.md) for portable syntax, image handling, and current limitations.

### Interactive browser (TUI)

Run `mdtyp` with no arguments to open the file browser:

```
mdtyp
```

```
┌─ mdtyp ──────────────────────────────────────────┐
│ /home/user/documents                              │
├───────────────────────────────────────────────────┤
│ ▶ projects/                                       │
│ ▶ notes/                                          │
│   readme.md                                       │
│   todo.md                                         │
│   image.png                                       │
├───────────────────────────────────────────────────┤
│ q Quit  o Editor  t → Typst  p → PDF             │
└───────────────────────────────────────────────────┘
```

**Navigation**

| Key | Action |
|---|---|
| `↑` / `↓` or `j` / `k` | Move selection |
| `Enter` | Open folder |
| `←` / `h` / `Backspace` | Go up one level |
| `q` | Quit |

**File actions** (available when a `.md` file is selected)

| Key | Action |
|---|---|
| `o` | Open in `$EDITOR` |
| `t` | Convert to Typst — writes `.typ` beside the source file |
| `p` | Convert to PDF — writes `.typ` then compiles with `typst` |

Hidden files and directories are not shown. Folders are listed before files. Non-Markdown files are visible but have no actions.

`$EDITOR` accepts quoted paths and arguments (for example, `code --wait`), without invoking a shell. It defaults to `vi`; invalid or unavailable commands produce an error notification.

---

### CLI

Convert a single file:

```bash
mdtyp input.md              # writes input.typ
mdtyp input.md -o out.typ   # explicit output path
mdtyp input.md --stdout     # print to stdout
mdtyp input.md --pdf        # also compile to PDF with typst
mdtyp input.md --latex      # writes input.tex
```

Convert all `.md` files in the current directory:

```bash
mdtyp --all
mdtyp --all --pdf
mdtyp --all --latex
```

Read from stdin:

```bash
echo "# Hello" | mdtyp
echo "# Hello" | mdtyp -o hello.typ
cat notes.md | mdtyp --stdout
cat notes.md | mdtyp --latex --stdout
```

With stdin, `--pdf` writes PDF bytes to stdout unless `-o` supplies the intermediate
Typst output path:

```bash
echo "# Hello" | mdtyp --pdf > hello.pdf
echo "# Hello" | mdtyp --pdf -o hello.typ   # writes hello.typ and hello.pdf
```

For stdin PDF output, relative images resolve from the current working directory; no intermediate files are created.

Do not combine `--latex` with `--pdf`, or file-input `--stdout` with `--pdf`.

Set paper size:

```bash
mdtyp input.md --paper a4
mdtyp input.md --paper us-letter
```

Paper settings also apply to the TUI and Python API. `--paper` overrides `[page].paper` in config.

Set page margins for Typst/PDF output (overrides `[page].margin` in config):

```bash
mdtyp input.md --margin 15mm --pdf
mdtyp --all --margin 1in
```

`--margin` accepts a Typst length or margin expression, such as
`"(x: 15mm, y: 20mm)"` for separate horizontal and vertical margins.
It also applies to the TUI (`mdtyp --margin 15mm`) and is rejected with `--latex`.
Typst validates margin expressions when compiling; generating `.typ` alone does
not validate them.

### Font and table appearance

Typst/PDF output defaults to **Helvetica**, falling back to **Arial**, and **horizontal table rules**. Override either per conversion:

```bash
mdtyp input.md --font "Arial" --table-style shaded-horizontal --pdf
mdtyp input.md --table-style cell
mdtyp --all --font "DejaVu Sans" --table-style vertical
echo "# Notes" | mdtyp --font "Arial"
```

| `--table-style` | Appearance |
|---|---|
| `horizontal` (default) | Horizontal rules between rows and along the top/bottom; no vertical rules |
| `shaded-horizontal` | No rules; alternating light-grey body rows, starting with the first body row; unshaded header |
| `cell` | Horizontal and vertical rules around every cell |
| `vertical` | Vertical rules between columns and along the sides; no horizontal rules |

CLI flags override config-file values, which override defaults. The same settings apply to the TUI (`mdtyp --font "Arial" --table-style cell`). Explicit `--font`, `--table-style`, or `--margin` with `--latex` is rejected; LaTeX output does not use the Typst presentation configuration.

Fonts must be installed where Typst compiles the document; mdtyp does not bundle them. The default font order is Helvetica, then Arial. Typst warns about unavailable families and uses the next available font. Config accepts a single family or an ordered list; `--font` replaces that setting with one family. Run `typst fonts` to list available families.

Use a custom config file:

```bash
mdtyp input.md --config my-config.toml
```

---

## Markdown → LaTeX output

Use `--latex` to render Markdown to LaTeX instead of Typst:

```bash
mdtyp input.md --latex             # writes input.tex
mdtyp input.md --latex --stdout    # print LaTeX to stdout
mdtyp --all --latex                # convert all .md files to .tex
```

The LaTeX renderer preserves Markdown math as LaTeX math and maps common Markdown features to standard LaTeX constructs, including sections, nested emphasis, lists with their starting numbers, blockquotes, tables, links, images, and verbatim code blocks. HTML tags and blocks are omitted; text between inline tags survives. Documents that use links, images, or strikethrough may need the usual LaTeX packages such as `hyperref`, `graphicx`, or `ulem` in the surrounding document preamble.

---

## Markdown → Typst mapping

| Markdown | Typst |
|---|---|
| `# H1` … `###### H6` | `= H1` … `====== H6` |
| `**bold**` | `#strong[bold]` |
| `_italic_` | `#emph[italic]` |
| `~~strike~~` | `#strike[...]` |
| `` `code` `` | `#raw("code")` |
| `[text](url)` | `#link("url")[text]` |
| `![alt](src)` | `#figure(image("src"), caption: "alt")` |
| `> quote` | `#quote[...]` |
| `---` | `#line(length: 100%)` |
| `$...$` | `$...$` (with LaTeX → Typst math translation) |
| `$$...$$` | `$ ... $` (display math) |
| Tables | `#table(columns: N, ...)` |
| Fenced code blocks | `#raw("...", lang: "lang", block: true)` |
| Bullet / ordered lists | `#list(...)` / `#enum(start: N, ...)` |

Text, URLs, image captions, and code are encoded for their Typst context rather than inserted as executable markup. Nested list items own all their child blocks; ordered starts are preserved. Ordinary HTML is omitted, except for the explicit directives below. Local image URL escapes are decoded, but assets are not downloaded, copied, or rebased when output moves.

CLI and TUI writes reject output paths that alias their input or another output in the same conversion, including symbolic and hard links. Outputs are staged before replacement. With `--pdf`, missing Typst or a compilation failure leaves both existing `.typ` and `.pdf` files unchanged. Successful publication uses separate renames for the two files, not a transaction; interruption during publication can leave a mismatched pair. Existing unrelated output files are still replaced on success.

### Table of contents

To insert a table of contents in Typst output, place this comment on its own
line, with blank lines around it, where the contents should appear:

```markdown
<!-- Table of contents -->
```

It becomes `#outline(title: [Table of contents])`, which automatically lists
headings with links and page numbers when compiled. The comment is hidden in
rendered Markdown. Capitalisation and whitespace within the comment are ignored.

For a question bank, use `<!-- Question index -->` instead. Annotate each question
heading with a comment immediately after it (separated by a blank line):

```markdown
<!-- Question index -->

#### Q1 — Lifetime probability

<!-- Question: Q1 | Exponential lifetime: survival given current age -->

The full question goes here, followed by its answer.
```

The index lists the question ID, the plain-text summary after `|`, and the
question heading's page number. Entries are clickable and page numbers update
when Typst compiles the document. Only annotated headings are included, so
answer headings and answer text do not appear in the index. A page break separates
the index from the body. Keep each annotation on one line and omit answers from
its summary.

### LaTeX math translation

Math expressions are translated from LaTeX to Typst syntax automatically:

| LaTeX | Typst |
|---|---|
| `\frac{a}{b}` | `frac(a, b)` |
| `\sqrt{x}` | `sqrt(x)` |
| `\alpha`, `\beta`, `\pi` … | `alpha`, `beta`, `pi` … |
| `x_{i}`, `x^{2}` | `x_(i)`, `x^(2)` |
| `\mathbf{F}` | `bold(F)` |
| `\mathbb{R}` | `RR` |
| `\binom{n}{k}` | `binom(n, k)` |
| `\ne`, `\mid` | `!=`, `\|` |
| `\cap`, `\bigcap`, `\emptyset` | `inter`, `inter.big`, `emptyset` |
| `\xrightarrow{N}` | `arrow.r^(N)` |
| `\begin{aligned}…\end{aligned}` | Typst aligned block |
| `\begin{pmatrix}…\end{pmatrix}` | Typst matrix |
| `\partial`, `\hbar` | `partial`, `planck` |
| `\oplus`, `\otimes` | `plus.o`, `times.o` |
| `\langle`, `\rangle` | `chevron.l`, `chevron.r` |

Text inside `\text{...}` stays literal through the entire translation pipeline, including matrix and alignment parsing. Adjacent supported commands keep their boundaries, so expressions such as `\eta\sqrt{x}` do not merge into a different command. Blackboard symbols such as `\mathbb{R}(x)` remain intact. Unsupported or malformed named commands raise `ValueError` in the Python API; CLI/TUI conversions report the error without replacing the output. Command names are matched as complete tokens, so an unknown command such as `\alphabet` is not silently rewritten as `\alpha` plus text.

Generated symbol identifiers are derived from the translation table so they cannot drift out of a separate allowlist. The mappings use [Typst's canonical symbol names](https://typst.app/docs/reference/symbols/sym/).

This remains a subset translator, not a full TeX validator or an untrusted-document sandbox. Configuration expressions and compiler resource access require trusted inputs.

---

## Configuration

Config file location: `~/.config/mdtyp/config.toml` (or `$XDG_CONFIG_HOME/mdtyp/config.toml`).

All fields are optional — omitted fields use defaults.

```toml
[table]
header_bold = true   # wrap header cells in *...*
style = "horizontal"  # horizontal, shaded-horizontal, cell, vertical
stroke = ""          # rule stroke; empty uses 0.5pt; shaded-horizontal ignores it

[blockquote]
function = "quote"   # Typst function name used for blockquotes

[hr]
style = "#line(length: 100%)"   # exact Typst output for ---

[image]
use_figure = true    # false emits bare #image() without #figure wrapper
width = ""           # e.g. "80%" — adds width: param to image()

[code]
block_function = ""  # e.g. "sourcecode" — wraps code blocks: #sourcecode[...]

[page]
paper = ""           # default paper size, e.g. "a4" (--paper flag overrides)
margin = ""          # Typst length, e.g. "15mm" (--margin overrides)
numbering = ""       # page-number pattern, e.g. "1"

[text]
font = ["Helvetica", "Arial"]  # ordered fallbacks; a single string also works (--font overrides)
size = ""            # Typst font size, e.g. "12pt"
```

For printable notes, save this as `print.toml`:

```toml
[page]
paper = "a4"
margin = "15mm"
numbering = "1"

[text]
size = "12pt"
```

```bash
mdtyp notes.md --config print.toml --pdf
mdtyp notes.md --config print.toml --margin 10mm --pdf
```

Page numbering and text size are config-only settings; there are no `--numbering`
or `--size` flags. Leave them empty to use Typst's defaults.

---

## Development

Use the examples as the main rendering check. Inspect the generated PDFs for formatting and mathematical fidelity; compilation alone does not prove either.

```bash
# Feature reference
uv run mdtyp examples/everything.md --pdf

# Longer documents with math, tables, and local images
(cd examples2 && uv run mdtyp --all --config print.toml --pdf)

# Small CLI smoke suite
uv run pytest -q
```

`tests/test_cli.py` checks file/stdin conversion, stdout, batch conversion, LaTeX/PDF output, and basic overwrite protection. Rendering coverage lives in the examples, not a separate unit-test suite. Extend the examples when a real document exposes a gap.

### Architecture

```
mdtyp/
├── cli.py          CLI entry point (Typer) + TUI launch
├── tui.py          Interactive file browser (Textual)
├── converter.py    convert(md_text) → typst_text
├── ctx.py          Ctx: token stream + output accumulator
├── handlers.py     Block-level token handlers
├── inline.py       Inline token rendering
├── latex2typst.py  LaTeX math → Typst math translation
├── latex.py        Markdown → LaTeX renderer
├── typst.py        Literal Typst string serialization
├── output.py       Source-preserving output writes
└── config.py       Config dataclass + TOML loader
```

The conversion pipeline:

```
Markdown text
    → markdown-it-py (with dollarmath + strikethrough plugins)
    → token stream
    → Ctx + render_tokens()  [handlers.py / inline.py]
    → latex_to_typst()       [latex2typst.py, math tokens only]
    → Typst text
```
