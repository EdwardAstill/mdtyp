"""Rendering context with token stream for the Markdown to Typst converter."""

from __future__ import annotations

from markdown_it.token import Token

from mdtyp.config import Config


class Ctx:
    """Accumulates Typst output and provides token stream access."""

    def __init__(self, tokens: list[Token], config: Config):
        self.tokens = tokens
        self.config = config
        self.i = 0
        self.out = ""
        self.list_stack: list[str] = []  # "bullet" | "ordered"
        self.item_first_para: bool = False  # True right after list_item_open

    def current(self) -> Token:
        return self.tokens[self.i]

    def peek(self, offset: int = 1) -> Token | None:
        idx = self.i + offset
        return self.tokens[idx] if idx < len(self.tokens) else None

    def advance(self, n: int = 1) -> None:
        self.i += n

    def has_more(self) -> bool:
        return self.i < len(self.tokens)

    def write(self, s: str) -> None:
        self.out += s

    def sub_context(self, tokens: list[Token]) -> Ctx:
        """Create a child context for recursive rendering (e.g. blockquotes)."""
        return Ctx(tokens, self.config)
