"""Block-level token handlers for the Markdown to Typst converter."""

from __future__ import annotations

from collections.abc import Callable

from mdtyp.config import Config
from mdtyp.ctx import Ctx
from mdtyp.inline import render_inline
from mdtyp.latex2typst import latex_to_typst


# --- Headings ---


def _handle_heading(ctx: Ctx) -> None:
    level = int(ctx.current().tag[1])
    prefix = "=" * level
    inline_tok = ctx.peek()
    content = render_inline(inline_tok.children or [], ctx.config) if inline_tok else ""
    ctx.write(f"\n{prefix} {content}\n\n")
    ctx.advance(3)  # heading_open + inline + heading_close


# --- Paragraphs ---


def _handle_paragraph(ctx: Ctx) -> None:
    inline_tok = ctx.peek()
    text = render_inline(inline_tok.children or [], ctx.config) if inline_tok else ""
    if ctx.list_stack and ctx.item_first_para:
        depth = len(ctx.list_stack) - 1
        indent = "  " * depth
        marker = "+" if ctx.list_stack[-1] == "ordered" else "-"
        ctx.write(f"{indent}{marker} {text}\n")
        ctx.item_first_para = False
    elif ctx.list_stack:
        depth = len(ctx.list_stack) - 1
        indent = "  " * (depth + 1)
        ctx.write(f"\n{indent}{text}\n")
    else:
        ctx.write(text + "\n\n")
    ctx.advance(3)  # paragraph_open + inline + paragraph_close


# --- Code blocks ---


def _handle_fence(ctx: Ctx) -> None:
    tok = ctx.current()
    info = tok.info.strip() if tok.info else ""
    content = tok.content.rstrip("\n")
    fn = ctx.config.code.block_function
    if fn:
        lang_attr = f'lang: "{info}", ' if info else ""
        ctx.write(f"#{fn}({lang_attr}```\n{content}\n```)\n\n")
    elif info:
        ctx.write(f"```{info}\n{content}\n```\n\n")
    else:
        ctx.write(f"```\n{content}\n```\n\n")
    ctx.advance()


def _handle_code_block(ctx: Ctx) -> None:
    content = ctx.current().content.rstrip("\n")
    fn = ctx.config.code.block_function
    if fn:
        ctx.write(f"#{fn}(```\n{content}\n```)\n\n")
    else:
        ctx.write(f"```\n{content}\n```\n\n")
    ctx.advance()


# --- Lists ---


def _handle_bullet_list_open(ctx: Ctx) -> None:
    ctx.list_stack.append("bullet")
    ctx.advance()


def _handle_ordered_list_open(ctx: Ctx) -> None:
    ctx.list_stack.append("ordered")
    ctx.advance()


def _handle_list_close(ctx: Ctx) -> None:
    ctx.list_stack.pop()
    if not ctx.list_stack:
        ctx.write("\n")
    ctx.advance()


def _handle_list_item_open(ctx: Ctx) -> None:
    ctx.item_first_para = True
    ctx.advance()


def _handle_list_item_close(ctx: Ctx) -> None:
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
    ctx.write(f"/* HTML: {ctx.current().content.strip()} */\n\n")
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
    if config.table.stroke:
        lines.append(f"  stroke: {config.table.stroke},")

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
    "fence": _handle_fence,
    "code_block": _handle_code_block,
    "bullet_list_open": _handle_bullet_list_open,
    "ordered_list_open": _handle_ordered_list_open,
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
