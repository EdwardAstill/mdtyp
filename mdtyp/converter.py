"""Markdown to Typst converter using markdown-it-py token stream."""

from __future__ import annotations

from markdown_it import MarkdownIt
from mdit_py_plugins.dollarmath import dollarmath_plugin

from mdtyp.config import Config
from mdtyp.ctx import Ctx
from mdtyp.handlers import render_tokens
from mdtyp.typst import typst_string


def convert(md_text: str, config: Config | None = None) -> str:
    """Convert Markdown text to Typst markup.

    Raises ValueError for unsupported or malformed LaTeX commands.
    """
    md = MarkdownIt().enable("table").enable("strikethrough")
    dollarmath_plugin(md, double_inline=True)
    tokens = md.parse(md_text)
    ctx = Ctx(tokens, config or Config())
    if ctx.config.page.paper:
        ctx.write(f"#set page(paper: {typst_string(ctx.config.page.paper)})\n\n")
    fonts = ctx.config.text.font
    if isinstance(fonts, str):
        fonts = [fonts]
    if not isinstance(fonts, list) or not fonts or any(
        not isinstance(font, str) or not font.strip() for font in fonts
    ):
        raise ValueError("Font must be a non-empty family name or list of family names")
    font_names = ", ".join(typst_string(font) for font in fonts)
    ctx.write(f"#set text(font: ({font_names},))\n")
    if ctx.config.page.margin:
        ctx.write(f"#set page(margin: {ctx.config.page.margin})\n")
    if ctx.config.page.numbering:
        ctx.write(f"#set page(numbering: {typst_string(ctx.config.page.numbering)})\n")
    if ctx.config.text.size:
        ctx.write(f"#set text(size: {ctx.config.text.size})\n")
    render_tokens(ctx)
    return ctx.out.strip() + "\n"
