# Markdown authoring guide for mdtyp

Use standard Markdown plus pipe tables, strikethrough, and dollar-delimited math. Keep presentation in [mdtyp configuration](README.md#configuration), not HTML, CSS, or raw Typst. This guide covers conversion-specific constraints rather than Markdown basics.

## Compatibility

- Soft line breaks become spaces; use paragraphs or Markdown hard breaks where needed.
- Ordered lists preserve the starting number, then renumber automatically. Use headings or prose labels for question IDs.
- Nested items may contain multiple paragraphs, code blocks, quotes, and sublists. Indent those blocks under their owning item; blank lines distinguish loose lists from tight lists.
- GitHub alerts such as `[!NOTE]` are not callouts; use `**Note:**`.
- Do not rely on YAML metadata, footnote/citation extensions, task checkboxes, definition lists, or heading IDs/attributes. Use ordinary prose and explicit references.
- HTML tags and blocks are omitted; text between inline tags survives. Unsupported extensions can lose meaning without an error.

## Links and images

Use explicit links; bare URLs are not guaranteed clickable. Heading fragments such as `#method` are not translated into Typst references, and relative `.md` links are not rewritten to PDFs. Refer to section titles or use the generated contents below. Link destinations are not validated.

```markdown
![Temperature measured over ten minutes](images/temperature.png)
```

- Put images in standalone paragraphs. Supply local assets: mdtyp neither downloads remote images nor copies assets.
- Keep generated `.typ` files beside the source, with assets beneath that directory. Moving output does not rebase relative paths.
- Prefer PNG/JPEG for portability; SVG depends on the renderer. Use forward slashes; wrap paths containing spaces in angle brackets. URL-escaped paths are decoded.
- Alt text becomes a visible figure caption by default. Captions are literal text with emphasis/code markers removed; put equations or complex formatting in nearby prose.
- Image titles, HTML tags, and attribute extensions do not control dimensions or captions. Configure width and figure wrapping outside the document.

Mermaid/Graphviz fences remain code; inline SVG is not rendered as an image. Export diagrams to local image assets first.

## Tables and code

Keep pipe-table cells on one source line. Merged cells, nested tables, block content, and HTML line breaks are not supported. Escape cell pipes as `\|`, even inside code or math; use `\mid` for mathematical bars. Inspect wide tables in the PDF.

Use simple language names in code fences, without filename/highlighting attributes. Fenced content stays literal, including math, HTML, and diagram syntax.

## Math

Use `$...$` inline and `$$` on separate lines for display math—not `\(...\)` or `\[...\]`. Viewers without math support may show the source.

```markdown
For $n$ observations:

$$
\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_{i}
$$
```

- Keep inline delimiters tight: `$x + y$`, not `$ x + y $`. Write currency as `USD 20` or `\$20`.
- Brace arguments, subscripts, and superscripts: `\frac{a}{b}`, `\sqrt{x}`, `x_{i}`, `x^{2}`.
- Separate multiplied variables: `a b` or `a \cdot b`. Unknown multi-letter runs may become a single textual identifier.
- Use standard LaTeX commands and `\text{...}` for words. Inside `\text`, braces group; `\{` and `\}` produce literal braces, and escaped punctuation stays literal.
- `aligned`, matrix, and cases environments are supported; inspect complex expressions in the PDF.
- Matrix environments include `matrix`, `pmatrix`, `bmatrix`, `Bmatrix`, `vmatrix`, and `Vmatrix`. Use `&` between cells and `\\` between rows.
- Compact forms such as `\frac12`, `\binom21`, `\sqrt x`, and `\hat x` are accepted; braced forms are clearer.
- Statistics notation includes `\ne`, `\mid`, `\cap`, `\bigcap`, `\emptyset`, and `\binom{n}{k}`. Write thousands separators as `6{,}149{,}520` and standalone unit powers as `m${}^3$`.
- Use `\xrightarrow{N}` or `\xleftarrow{N}` for labelled arrows.
- This is a LaTeX subset, not a TeX engine: no arbitrary package commands, custom macros, `\newcommand`, equation labels/references, or document environments. Use prose equation numbers.

Unsupported or malformed named commands stop conversion (`ValueError` in `convert()` / `latex_to_typst()`); the CLI leaves existing output untouched. Other invalid expressions may pass, so conversion success does not establish mathematical fidelity.

## Optional directives

Place directives on separate lines with surrounding blank lines. Ordinary Markdown viewers hide them.

Generated table of contents:

```markdown
<!-- Table of contents -->
```

Question index, with annotations immediately after their headings:

```markdown
<!-- Question index -->

## Q1 — Lifetime probability

<!-- Question: Q1 | Survival probability given current age -->
```

Keep annotations on one line with unique IDs and plain-text summaries, not answers. The index includes only annotated headings, adds clickable entries and page numbers, and inserts a page break before the body.

## Verification and output

```bash
uv run mdtyp document.md --stdout
uv run mdtyp document.md --pdf
```

Omit `uv run` for an installed tool. `--pdf` requires Typst and replaces sibling `.typ`/`.pdf` outputs only after compilation succeeds; missing or failed Typst leaves both existing files unchanged. The final replacements are separate renames, not a transaction. CLI/TUI writes reject input aliases, including symbolic and hard links. Stdin PDF output resolves relative images from the current working directory without creating intermediate files. Paper settings apply consistently to the CLI, TUI, and Python API.

Check assets and links, inspect generated Typst for lost content, then inspect PDF equations, tables, captions, images, and page breaks. The examples are the main rendering check; automated tests only smoke-check commands and basic overwrite protection. Compilation alone does not prove rendering or mathematical fidelity. `--latex` is a separate workflow, not a rendering-equivalence guarantee.

Typst/PDF defaults to Helvetica, with Arial as its fallback, and horizontal table rules. Override margins, font, and table style at conversion time:

```bash
uv run mdtyp document.md --margin 15mm --font "Arial" --table-style shaded-horizontal --pdf
```

Table styles: `horizontal`, `shaded-horizontal` (alternating grey body rows, no rules), `cell` (both rule directions), `vertical`. Flags override `[page].margin`, `[text].font`, and `[table].style`, including when launching the TUI. These three flags cannot be used with `--latex`. Configured fonts can be a single family or an ordered list such as `["Helvetica", "Arial"]`; `--font` replaces the list with one family. Missing fonts trigger substitution; check availability with `typst fonts`.

Use `--margin "(x: 15mm, y: 20mm)"` for separate horizontal and vertical margins.
Margin expressions are evaluated by Typst during compilation, not validated by
conversion alone. Set page numbering (`[page].numbering`) and font size
(`[text].size`) in a TOML config; see the [print configuration example](README.md#configuration).
