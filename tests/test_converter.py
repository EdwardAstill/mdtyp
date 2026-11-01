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



# --- Inline formatting ---

def test_strikethrough() -> None:
    assert "#strike[strike]" in convert("~~strike~~")


def test_link() -> None:
    result = convert("[text](https://example.com)")
    assert '#link("https://example.com")[text]' in result


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


# --- Horizontal rule ---

def test_hr() -> None:
    result = convert("---")
    assert "#line(length: 100%)" in result


@pytest.mark.parametrize("marker", [
    "<!-- Table of contents -->",
    "<!-- table of contents -->",
    "<!--\nTable of contents\n-->",
])
def test_table_of_contents(marker: str) -> None:
    result = convert(f"# Notes\n\n{marker}\n\n## Section\n\nText")
    assert result.count("#outline(") == 1
    assert result.index("= Notes") < result.index("#outline(") < result.index("== Section")
    assert "<!--" not in result


def test_table_of_contents_example_in_code_stays_literal() -> None:
    result = convert("```markdown\n<!-- Table of contents -->\n```")
    assert "#outline(" not in result
    assert "<!-- Table of contents -->" in result


def test_question_index_uses_only_explicit_summaries() -> None:
    result = convert(
        '# Notes\n\n<!-- Question index -->\n\n'
        '#### Q1\n\n<!-- Question: Q1 | Normal upper-tail probability -->\n\n'
        'Find the probability.\n\n##### Answer\n\nSecret answer.\n'
    )
    assert 'query(metadata).filter(q => type(q.value) == dictionary and q.value.at("kind", default: none) == "mdtyp-question")' in result
    assert 'counter(page).at(q.location())' in result
    assert result.count('#metadata(') == 1
    assert '==== Q1 #metadata((kind: "mdtyp-question", id: "Q1", summary: "Normal upper-tail probability"))' in result
    assert 'summary: "Secret answer' not in result
    assert '===== Answer' in result
    assert '<!-- Question:' not in result


def test_question_summary_is_escaped_as_plain_text() -> None:
    result = convert('## Q1\n\n<!-- Question: Q1 | Find "x"; #text[not code] -->')
    assert r'summary: "Find \"x\"; #text[not code]"' in result


def test_question_annotation_does_not_consume_following_content() -> None:
    result = convert('## Q1\n\n<!-- Question: Q1 | Probability -->\n\nPrompt\n\n## Q2')
    assert 'Prompt' in result
    assert '== Q2' in result
    assert result.count('#metadata(') == 1


def test_question_markers_in_code_are_not_processed() -> None:
    result = convert('```markdown\n<!-- Question index -->\n## Q1\n'
                     '<!-- Question: Q1 | Probability -->\n```')
    assert '#metadata(' not in result
    assert 'query(' not in result


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


