"""Inline token rendering for the Markdown to Typst converter."""

from __future__ import annotations

from collections.abc import Callable

from markdown_it.token import Token

from mdtyp.config import Config
from mdtyp.latex2typst import latex_to_typst

_TYPST_ESCAPE = str.maketrans({
    "\\": "\\\\",
    "$": r"\$",
    "*": r"\*",
    "_": r"\_",
    "#": r"\#",
    "@": r"\@",
    "~": r"\~",
    "<": r"\<",
    ">": r"\>",
})


def escape_typst(text: str) -> str:
    """Escape characters that have special meaning in Typst markup."""
    return text.translate(_TYPST_ESCAPE)


def render_inline(children: list[Token], config: Config) -> str:
    """Render a list of inline tokens to Typst markup."""
    out = ""
    i = 0
    while i < len(children):
        tok = children[i]
        handler = _INLINE_HANDLERS.get(tok.type)
        if handler:
            result, i = handler(children, i, config)
            out += result
        else:
            i += 1
    return out


# Handler signature: (children, index, config) -> (rendered_string, new_index)
_InlineHandler = Callable[[list[Token], int, Config], tuple[str, int]]


def _collect_until(
    children: list[Token], start: int, close_type: str,
) -> tuple[list[Token], int]:
    """Collect tokens from start until close_type. Returns (inner_tokens, close_index)."""
    j = start
    inner: list[Token] = []
    while j < len(children) and children[j].type != close_type:
        inner.append(children[j])
        j += 1
    return inner, j


# --- Simple inline handlers ---


def _handle_text(children: list[Token], i: int, config: Config) -> tuple[str, int]:
    return escape_typst(children[i].content), i + 1


def _handle_softbreak(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    return " ", i + 1


def _handle_hardbreak(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    return "\\\n", i + 1


def _handle_code_inline(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    return f"`{children[i].content}`", i + 1


def _handle_math_inline(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    return f"${latex_to_typst(children[i].content)}$", i + 1


def _handle_html_inline(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    return f"/* {children[i].content.strip()} */", i + 1


def _handle_image(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    tok = children[i]
    src = tok.attrGet("src") or ""
    alt = tok.content or ""
    img_cfg = config.image
    width_arg = f", width: {img_cfg.width}" if img_cfg.width else ""
    if img_cfg.use_figure:
        result = f'#figure(image("{src}"{width_arg}), caption: [{alt}])'
    else:
        result = f'#image("{src}"{width_arg})'
    return result, i + 1


# --- Wrapping inline handlers (open/close pairs) ---


def _handle_strong(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    inner, j = _collect_until(children, i + 1, "strong_close")
    content = render_inline(inner, config)
    return (f"*{content}*" if content else ""), j + 1


def _handle_em(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    inner, j = _collect_until(children, i + 1, "em_close")
    content = render_inline(inner, config)
    return (f"_{content}_" if content else ""), j + 1


def _handle_strikethrough(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    inner, j = _collect_until(children, i + 1, "s_close")
    return f"#strike[{render_inline(inner, config)}]", j + 1


def _handle_link(
    children: list[Token], i: int, config: Config,
) -> tuple[str, int]:
    href = children[i].attrGet("href") or ""
    inner, j = _collect_until(children, i + 1, "link_close")
    label = render_inline(inner, config)
    return f'#link("{href}")[{label}]', j + 1


_INLINE_HANDLERS: dict[str, _InlineHandler] = {
    "text": _handle_text,
    "softbreak": _handle_softbreak,
    "hardbreak": _handle_hardbreak,
    "code_inline": _handle_code_inline,
    "math_inline": _handle_math_inline,
    "html_inline": _handle_html_inline,
    "image": _handle_image,
    "strong_open": _handle_strong,
    "em_open": _handle_em,
    "s_open": _handle_strikethrough,
    "link_open": _handle_link,
}
