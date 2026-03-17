"""Markdown to Typst converter using markdown-it-py token stream."""

from markdown_it import MarkdownIt
from markdown_it.token import Token
from mdit_py_plugins.dollarmath import dollarmath_plugin

from md2typst.latex2typst import latex_to_typst


def convert(md_text: str) -> str:
    md = MarkdownIt().enable("table")
    dollarmath_plugin(md, double_inline=True)
    tokens = md.parse(md_text)
    ctx = _Ctx()
    _render_tokens(tokens, ctx)
    return ctx.out.strip() + "\n"


class _Ctx:
    def __init__(self):
        self.out = ""
        self.list_stack: list[str] = []  # "bullet" | "ordered"
        self.item_first_para: bool = False  # True right after list_item_open

    def write(self, s: str):
        self.out += s


def _render_tokens(tokens: list[Token], ctx: _Ctx):
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        t = tok.type

        # --- headings: consume open + inline + close ---
        if t == "heading_open":
            level = int(tok.tag[1])
            prefix = "=" * level
            inline = tokens[i + 1]
            ctx.write(f"\n{prefix} {_render_inline(inline.children or [])}\n\n")
            i += 3
            continue

        # --- paragraphs ---
        elif t == "paragraph_open":
            inline = tokens[i + 1]
            text = _render_inline(inline.children or [])
            if ctx.list_stack and ctx.item_first_para:
                # first paragraph of a list item → emit marker
                depth = len(ctx.list_stack) - 1
                indent = "  " * depth
                kind = ctx.list_stack[-1]
                marker = "+" if kind == "ordered" else "-"
                ctx.write(f"{indent}{marker} {text}\n")
                ctx.item_first_para = False
            elif ctx.list_stack:
                # continuation paragraph inside a list item
                depth = len(ctx.list_stack) - 1
                indent = "  " * (depth + 1)
                ctx.write(f"{indent}{text}\n")
            else:
                ctx.write(text + "\n\n")
            i += 3  # paragraph_open, inline, paragraph_close
            continue

        # --- fenced code blocks ---
        elif t == "fence":
            info = tok.info.strip() if tok.info else ""
            content = tok.content.rstrip("\n")
            if info:
                ctx.write(f"```{info}\n{content}\n```\n\n")
            else:
                ctx.write(f"```\n{content}\n```\n\n")

        elif t == "code_block":
            content = tok.content.rstrip("\n")
            ctx.write(f"```\n{content}\n```\n\n")

        # --- lists ---
        elif t == "bullet_list_open":
            ctx.list_stack.append("bullet")

        elif t == "ordered_list_open":
            ctx.list_stack.append("ordered")

        elif t in ("bullet_list_close", "ordered_list_close"):
            ctx.list_stack.pop()
            if not ctx.list_stack:
                ctx.write("\n")

        elif t == "list_item_open":
            ctx.item_first_para = True

        elif t == "list_item_close":
            pass

        # --- blockquotes ---
        elif t == "blockquote_open":
            j = i + 1
            content_parts = []
            nesting = 0
            while j < len(tokens):
                inner = tokens[j]
                if inner.type == "blockquote_open":
                    nesting += 1
                elif inner.type == "blockquote_close":
                    if nesting == 0:
                        i = j
                        break
                    nesting -= 1
                elif inner.type == "inline":
                    content_parts.append(_render_inline(inner.children or []))
                j += 1
            body = "\n\n".join(content_parts)
            ctx.write(f"#quote[\n{body}\n]\n\n")

        elif t == "hr":
            ctx.write("#line(length: 100%)\n\n")

        elif t == "html_block":
            ctx.write(f"/* HTML: {tok.content.strip()} */\n\n")

        # --- math ---
        elif t == "math_block":
            content = latex_to_typst(tok.content.strip())
            ctx.write(f"$ {content} $\n\n")

        # --- tables ---
        elif t == "table_open":
            i, table_out = _render_table(tokens, i)
            ctx.write(table_out)
            continue

        i += 1


def _render_table(tokens: list[Token], start: int) -> tuple[int, str]:
    """Consume table tokens and return (new_index, typst_table_string)."""
    alignments: list[str] = []
    header_cells: list[str] = []
    body_rows: list[list[str]] = []
    in_head = False
    in_body = False
    current_row: list[str] = []
    i = start + 1

    while i < len(tokens):
        t = tokens[i].type
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
            style = tokens[i].attrGet("style") or ""
            if "left" in style:
                alignments.append("left")
            elif "right" in style:
                alignments.append("right")
            elif "center" in style:
                alignments.append("center")
            elif not in_body or not alignments:
                alignments.append("auto")
        elif t == "inline":
            current_row.append(_render_inline(tokens[i].children or []))
        elif t == "table_close":
            i += 1
            break
        i += 1

    cols = len(header_cells) or (len(body_rows[0]) if body_rows else 1)
    col_spec = ", ".join(alignments[:cols])

    lines = ["#table("]
    lines.append(f"  columns: {cols},")
    lines.append(f"  align: ({col_spec},),")

    # header cells bold
    for cell in header_cells:
        lines.append(f"  [*{cell}*],")
    for row in body_rows:
        for cell in row:
            lines.append(f"  [{cell}],")
    lines.append(")\n")

    return i, "\n".join(lines)


def _render_inline(children: list[Token]) -> str:
    out = ""
    i = 0
    while i < len(children):
        tok = children[i]
        t = tok.type

        if t == "text":
            out += tok.content.replace("$", r"\$")

        elif t == "softbreak":
            out += " "

        elif t == "hardbreak":
            out += "\\\n"

        elif t == "code_inline":
            out += f"`{tok.content}`"

        elif t == "strong_open":
            j = i + 1
            inner = []
            while j < len(children) and children[j].type != "strong_close":
                inner.append(children[j])
                j += 1
            out += f"*{_render_inline(inner)}*"
            i = j

        elif t == "em_open":
            j = i + 1
            inner = []
            while j < len(children) and children[j].type != "em_close":
                inner.append(children[j])
                j += 1
            out += f"_{_render_inline(inner)}_"
            i = j

        elif t == "s_open":
            j = i + 1
            inner = []
            while j < len(children) and children[j].type != "s_close":
                inner.append(children[j])
                j += 1
            out += f"#strike[{_render_inline(inner)}]"
            i = j

        elif t == "link_open":
            href = tok.attrGet("href") or ""
            j = i + 1
            inner = []
            while j < len(children) and children[j].type != "link_close":
                inner.append(children[j])
                j += 1
            label = _render_inline(inner)
            out += f'#link("{href}")[{label}]'
            i = j

        elif t == "image":
            src = tok.attrGet("src") or ""
            alt = tok.attrGet("alt") or ""
            out += f'#figure(image("{src}"), caption: [{alt}])'

        elif t == "math_inline":
            out += f"${latex_to_typst(tok.content)}$"

        elif t == "html_inline":
            out += f"/* {tok.content.strip()} */"

        i += 1

    return out
