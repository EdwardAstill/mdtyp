"""Block-level token handlers for the Markdown to Typst converter."""

from __future__ import annotations

from collections.abc import Callable
import re

from mdtyp.config import Config, TableStyle
from mdtyp.ctx import Ctx
from mdtyp.inline import render_inline
from mdtyp.latex2typst import latex_to_typst
from mdtyp.typst import typst_string


# --- Headings ---


def _handle_heading(ctx: Ctx) -> None:
    level = int(ctx.current().tag[1])
    prefix = "=" * level
    inline_tok = ctx.peek()
    content = render_inline(inline_tok.children or [], ctx.config) if inline_tok else ""
    annotation = ctx.peek(3)
    question = (
        re.fullmatch(r"<!--\s*Question:\s*([^|\n]+)\|\s*(.+?)\s*-->",
                     annotation.content.strip(), re.IGNORECASE)
        if annotation and annotation.type == "html_block" else None
    )
    if question:
        identifier, summary = (typst_string(part.strip()) for part in question.groups())
        content += f' #metadata((kind: "mdtyp-question", id: {identifier}, summary: {summary}))'
    ctx.write(f"\n{prefix} {content}\n\n")
    ctx.advance(4 if question else 3)  # heading tokens + optional annotation


# --- Paragraphs ---


def _handle_paragraph(ctx: Ctx) -> None:
    inline_tok = ctx.peek()
    text = render_inline(inline_tok.children or [], ctx.config) if inline_tok else ""
    ctx.write(text + ("\n" if ctx.current().hidden else "\n\n"))
    ctx.advance(3)  # paragraph_open + inline + paragraph_close


# --- Code blocks ---


def _handle_code_block(ctx: Ctx) -> None:
    tok = ctx.current()
    info = tok.info.strip()
    content = typst_string(tok.content.removesuffix("\n"))
    lang_attr = f"lang: {typst_string(info)}, " if info else ""
    fn = ctx.config.code.block_function
    if fn:
        ctx.write(f"#{fn}({lang_attr}raw({content}, block: true))\n\n")
    else:
        ctx.write(f"#raw({lang_attr}{content}, block: true)\n\n")
    ctx.advance()


# --- Lists ---


def _handle_list_open(ctx: Ctx) -> None:
    tok = ctx.current()
    tight = True
    for index in range(ctx.i + 1, len(ctx.tokens)):
        child = ctx.tokens[index]
        if child.level == tok.level:
            break
        if child.type == "paragraph_open" and child.level == tok.level + 2 and not child.hidden:
            tight = False
            break
    if tok.type == "ordered_list_open":
        ctx.write(f"#enum(start: {tok.attrs.get('start', 1)}, ")
    else:
        ctx.write("#list(")
    ctx.write(f"tight: {str(tight).lower()},\n")
    ctx.advance()


def _handle_list_close(ctx: Ctx) -> None:
    ctx.write(")\n\n")
    ctx.advance()


def _handle_list_item_open(ctx: Ctx) -> None:
    ctx.write("[\n")
    ctx.advance()


def _handle_list_item_close(ctx: Ctx) -> None:
    ctx.write("],\n")
    ctx.advance()


# --- Blockquotes ---


def _handle_blockquote(ctx: Ctx) -> None:
    j = ctx.i + 1
    nesting = 0
    inner_tokens = []
    while j < len(ctx.tokens):
        tok = ctx.tokens[j]
        if tok.type == "blockquote_open":
            nesting += 1
        elif tok.type == "blockquote_close":
            if nesting == 0:
                break
            nesting -= 1
        inner_tokens.append(tok)
        j += 1
    inner_ctx = ctx.sub_context(inner_tokens)
    render_tokens(inner_ctx)
    body = inner_ctx.out.strip()
    fn = ctx.config.blockquote.function
    ctx.write(f"#{fn}[\n{body}\n]\n\n")
    ctx.i = j + 1


# --- Simple block tokens ---


def _handle_hr(ctx: Ctx) -> None:
    ctx.write(ctx.config.hr.style + "\n\n")
    ctx.advance()


def _handle_html_block(ctx: Ctx) -> None:
    content = ctx.current().content.strip()
    directive = " ".join(content[4:-3].split()).casefold()
    if content.startswith("<!--") and content.endswith("-->") and (
        directive == "table of contents"
    ):
        ctx.write('#outline(title: [Table of contents])\n\n')
    elif content.startswith("<!--") and content.endswith("-->") and (
        directive == "question index"
    ):
        ctx.write('''#heading(level: 2, outlined: false)[Question index]
Find a similar question by its topic, then turn to the page shown.

#context table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  stroke: none,
  inset: (x: 5pt, y: 3pt),
  table.header([*Question*], [*What it asks*], [*Page*]),
  ..query(metadata).filter(q => type(q.value) == dictionary and q.value.at("kind", default: none) == "mdtyp-question").map(q => {
    let fmt = q.location().page-numbering()
    (
      link(q.location(), q.value.id),
      link(q.location(), q.value.summary),
      link(q.location(), numbering(if fmt == none { "1" } else { fmt },
        ..counter(page).at(q.location()))),
    )
  }).flatten(),
)
#pagebreak()

''')
    ctx.advance()


def _handle_math_block(ctx: Ctx) -> None:
    content = latex_to_typst(ctx.current().content.strip())
    ctx.write(f"$ {content} $\n\n")
    ctx.advance()


# --- Tables ---


def _handle_table(ctx: Ctx) -> None:
    alignments, header_cells, body_rows = _parse_table_data(ctx)
    ctx.write(_format_table(alignments, header_cells, body_rows, ctx.config))


def _parse_table_data(
    ctx: Ctx,
) -> tuple[list[str], list[str], list[list[str]]]:
    """Parse table tokens from ctx, advancing past them.
    Returns (alignments, header_cells, body_rows).
    """
    alignments: list[str] = []
    header_cells: list[str] = []
    body_rows: list[list[str]] = []
    in_head = False
    in_body = False
    current_row: list[str] = []
    ctx.advance()  # skip table_open

    while ctx.has_more():
        tok = ctx.current()
        t = tok.type
        if t == "thead_open":
            in_head = True
        elif t == "thead_close":
            in_head = False
        elif t == "tbody_open":
            in_body = True
        elif t == "tbody_close":
            in_body = False
        elif t == "tr_open":
            current_row = []
        elif t == "tr_close":
            if in_head:
                header_cells = current_row[:]
            elif in_body:
                body_rows.append(current_row[:])
        elif t in ("th_open", "td_open"):
            style = tok.attrGet("style") or ""
            if "left" in style:
                alignments.append("left")
            elif "right" in style:
                alignments.append("right")
            elif "center" in style:
                alignments.append("center")
            elif not in_body or not alignments:
                alignments.append("auto")
        elif t == "inline":
            current_row.append(render_inline(tok.children or [], ctx.config))
        elif t == "table_close":
            ctx.advance()
            break
        ctx.advance()

    return alignments, header_cells, body_rows


def _format_table(
    alignments: list[str],
    header_cells: list[str],
    body_rows: list[list[str]],
    config: Config,
) -> str:
    """Format parsed table data into Typst table syntax."""
    cols = len(header_cells) or (len(body_rows[0]) if body_rows else 1)
    col_spec = ", ".join(alignments[:cols])

    lines = ["#table("]
    lines.append(f"  columns: {cols},")
    lines.append(f"  align: ({col_spec},),")
    style = TableStyle(config.table.style)
    stroke = config.table.stroke or "0.5pt"
    if style == TableStyle.SHADED_HORIZONTAL:
        lines.append("  stroke: none,")
        lines.append("  fill: (x, y) => if calc.odd(y) { luma(94%) } else { none },")
    elif style == TableStyle.HORIZONTAL:
        lines.append(f"  stroke: (x: none, y: {stroke}),")
    elif style == TableStyle.VERTICAL:
        lines.append(f"  stroke: (x: {stroke}, y: none),")
    else:
        lines.append(f"  stroke: {stroke},")

    if header_cells:
        lines.append("  table.header(")
        for cell in header_cells:
            if config.table.header_bold and cell:
                lines.append(f"    [*{cell}*],")
            else:
                lines.append(f"    [{cell}],")
        lines.append("  ),")

    for row in body_rows:
        for cell in row:
            lines.append(f"  [{cell}],")
    lines.append(")\n")

    return "\n".join(lines)


# --- Handler registry ---


BLOCK_HANDLERS: dict[str, Callable[[Ctx], None]] = {
    "heading_open": _handle_heading,
    "paragraph_open": _handle_paragraph,
    "fence": _handle_code_block,
    "code_block": _handle_code_block,
    "bullet_list_open": _handle_list_open,
    "ordered_list_open": _handle_list_open,
    "bullet_list_close": _handle_list_close,
    "ordered_list_close": _handle_list_close,
    "list_item_open": _handle_list_item_open,
    "list_item_close": _handle_list_item_close,
    "blockquote_open": _handle_blockquote,
    "hr": _handle_hr,
    "html_block": _handle_html_block,
    "math_block": _handle_math_block,
    "table_open": _handle_table,
}


def render_tokens(ctx: Ctx) -> None:
    """Process block-level tokens by dispatching to registered handlers."""
    while ctx.has_more():
        handler = BLOCK_HANDLERS.get(ctx.current().type)
        if handler:
            handler(ctx)
        else:
            import warnings
            warnings.warn(f"Unsupported block token type: {ctx.current().type}", stacklevel=2)
            ctx.advance()
