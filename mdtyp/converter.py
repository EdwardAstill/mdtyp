"""Markdown to Typst converter using markdown-it-py token stream."""

from __future__ import annotations

import json

from markdown_it import MarkdownIt
from mdit_py_plugins.dollarmath import dollarmath_plugin

from mdtyp.config import Config
from mdtyp.ctx import Ctx
from mdtyp.handlers import render_tokens


def convert(md_text: str, config: Config | None = None) -> str:
    """Convert Markdown text to Typst markup."""
    md = MarkdownIt().enable("table").enable("strikethrough")
    dollarmath_plugin(md, double_inline=True)
    tokens = md.parse(md_text)
    ctx = Ctx(tokens, config or Config())
    if ctx.config.page.margin:
        ctx.write(f"#set page(margin: {ctx.config.page.margin})\n")
    if ctx.config.page.numbering:
        ctx.write(f"#set page(numbering: {json.dumps(ctx.config.page.numbering)})\n")
    if ctx.config.text.size:
        ctx.write(f"#set text(size: {ctx.config.text.size})\n")
    render_tokens(ctx)
    return ctx.out.strip() + "\n"
