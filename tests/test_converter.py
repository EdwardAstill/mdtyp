"""Unit tests for the Markdown → Typst converter."""

import pytest

from mdtyp.converter import convert
from mdtyp.config import Config, TableConfig, ImageConfig, BlockquoteConfig


# --- Headings ---

@pytest.mark.parametrize("md, prefix", [
    ("# H1", "= H1"),
    ("## H2", "== H2"),
    ("### H3", "=== H3"),
    ("#### H4", "==== H4"),
    ("##### H5", "===== H5"),
    ("###### H6", "====== H6"),
])
def test_headings(md: str, prefix: str) -> None:
    result = convert(md)
    assert prefix in result


def test_heading_with_formatting() -> None:
    result = convert("## **bold** heading")
    assert "*bold*" in result
    assert "==" in result


# --- Inline formatting ---

def test_bold() -> None:
    assert "*bold*" in convert("**bold**")


def test_italic() -> None:
    assert "_italic_" in convert("_italic_")


def test_strikethrough() -> None:
    assert "#strike[strike]" in convert("~~strike~~")


def test_inline_code() -> None:
    assert "`code`" in convert("`code`")


def test_link() -> None:
    result = convert("[text](https://example.com)")
    assert '#link("https://example.com")[text]' in result


def test_image() -> None:
    result = convert("![Alt text](photo.jpg)")
    assert '#figure(image("photo.jpg")' in result
    assert "caption: [Alt text]" in result


def test_image_no_figure() -> None:
    config = Config(image=ImageConfig(use_figure=False))
    result = convert("![alt](img.png)", config)
    assert '#image("img.png")' in result
    assert "figure" not in result


def test_image_width() -> None:
    config = Config(image=ImageConfig(width="80%"))
    result = convert("![alt](img.png)", config)
    assert "width: 80%" in result


# --- Math ---

def test_inline_math() -> None:
    result = convert("$x^2$")
    assert "$x^2$" in result


def test_display_math() -> None:
    result = convert("$$\nx = 1\n$$")
    assert "$ x = 1 $" in result


# --- Code blocks ---

def test_fenced_code_with_lang() -> None:
    result = convert("```python\nprint(1)\n```")
    assert "```python" in result
    assert "print(1)" in result


def test_fenced_code_no_lang() -> None:
    result = convert("```\nplain text\n```")
    assert "```\nplain text\n```" in result


def test_indented_code() -> None:
    result = convert("    indented code")
    assert "indented code" in result
    assert "```" in result


# --- Lists ---

def test_unordered_list() -> None:
    result = convert("- one\n- two\n- three")
    assert "- one" in result
    assert "- two" in result
    assert "- three" in result


def test_ordered_list() -> None:
    result = convert("1. one\n2. two")
    assert "+ one" in result
    assert "+ two" in result


def test_nested_list() -> None:
    result = convert("- top\n  - nested\n- back")
    assert "- top" in result
    assert "  - nested" in result
    assert "- back" in result


def test_mixed_nested_list() -> None:
    result = convert("1. ordered\n   - bullet child")
    assert "+ ordered" in result
    assert "  - bullet child" in result


# --- Blockquotes ---

def test_blockquote() -> None:
    result = convert("> hello")
    assert "#quote[\nhello\n]" in result


def test_nested_blockquote() -> None:
    result = convert("> > nested")
    assert "#quote[" in result
    # Should contain two levels of #quote
    assert result.count("#quote[") == 2


def test_blockquote_custom_function() -> None:
    config = Config(blockquote=BlockquoteConfig(function="callout"))
    result = convert("> hello", config)
    assert "#callout[" in result


# --- Tables ---

def test_simple_table() -> None:
    md = "| A | B |\n|---|---|\n| 1 | 2 |"
    result = convert(md)
    assert "#table(" in result
    assert "columns: 2" in result
    assert "table.header(" in result
    assert "[*A*]" in result
    assert "[1]" in result


def test_table_alignment() -> None:
    md = "| L | C | R |\n|:--|:-:|--:|\n| a | b | c |"
    result = convert(md)
    assert "left" in result
    assert "center" in result
    assert "right" in result


def test_table_no_bold_headers() -> None:
    config = Config(table=TableConfig(header_bold=False))
    md = "| A |\n|---|\n| 1 |"
    result = convert(md, config)
    assert "[A]" in result
    assert "[*A*]" not in result


def test_table_stroke() -> None:
    config = Config(table=TableConfig(stroke="0.5pt"))
    md = "| A |\n|---|\n| 1 |"
    result = convert(md, config)
    assert "stroke: 0.5pt" in result


# --- Horizontal rule ---

def test_hr() -> None:
    result = convert("---")
    assert "#line(length: 100%)" in result


# --- HTML ---

def test_html_inline() -> None:
    result = convert("text <b>bold</b> text")
    assert "/* <b> */" in result


def test_html_block() -> None:
    result = convert("<div>block</div>")
    assert "/* HTML:" in result


# --- Special characters ---

def test_escape_special_chars() -> None:
    result = convert("# $ * _ @ ~ < >")
    # In the heading content, special chars should be escaped
    assert "\\$" in result
    assert "\\*" in result
    assert "\\@" in result


# --- Soft/hard breaks ---

def test_softbreak() -> None:
    result = convert("line one\nline two")
    assert "line one line two" in result


# --- Smoke test: everything.md ---

def test_everything_md_does_not_crash() -> None:
    """Smoke test: converting everything.md should not raise."""
    from pathlib import Path
    everything = Path(__file__).parent.parent / "examples" / "everything.md"
    if everything.exists():
        md_text = everything.read_text()
        result = convert(md_text)
        assert len(result) > 100
