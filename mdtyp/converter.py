"""Markdown to Typst converter using markdown-it-py token stream."""

from __future__ import annotations

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
    render_tokens(ctx)
    return ctx.out.strip() + "\n"
