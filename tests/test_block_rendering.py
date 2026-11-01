"""Compiler-backed regressions for block ownership and literal content."""

import json
import shutil
import subprocess

import pytest

from mdtyp.config import Config
from mdtyp.converter import convert


pytestmark = pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")


def _query(tmp_path, markdown, selector, *, config=None, prelude=""):
    source = tmp_path / "document.typ"
    source.write_text(prelude + convert(markdown, config), encoding="utf-8")
    result = subprocess.run(
        ["typst", "query", str(source), selector], capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    return json.loads(result.stdout)


def _walk(value):
    if isinstance(value, dict):
        yield value
        for child in value.values():
            yield from _walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from _walk(child)


def _text(value):
    return "".join(node["text"] for node in _walk(value) if node.get("func") == "text")


def test_list_items_own_all_their_blocks(tmp_path):
    markdown = '''3. Parent

   Another paragraph

   ```text
   Literal code
   ```

   > Quoted child

   - Nested child

   Back in parent

   | Header |
   | --- |
   | Cell |

   $$
   x^2
   $$

4. Sibling
'''
    enums = _query(tmp_path, markdown, "enum")
    assert len(enums) == 1
    outer = enums[0]
    assert outer["start"] == 3
    assert outer["tight"] is False
    assert len(outer["children"]) == 2
    first, second = (item["body"] for item in outer["children"])
    assert {"raw", "quote", "list", "table", "equation"} <= {
        node.get("func") for node in _walk(first)
    }
    assert "Back in parent" in _text(first)
    assert "Sibling" not in _text(first)
    assert _text(second) == "Sibling"


def test_parent_continues_after_child_without_paragraph(tmp_path):
    markdown = "- Parent\n\n  - > Child quote\n\n  Parent continuation\n\n- Sibling\n"
    lists = _query(tmp_path, markdown, "list")
    outer = next(item for item in lists if len(item["children"]) == 2)
    parent = outer["children"][0]["body"]
    nested = next(node for node in _walk(parent) if node.get("func") == "list")
    assert "Parent continuation" in _text(parent)
    assert "Parent continuation" not in _text(nested)
    assert _text(outer["children"][1]["body"]) == "Sibling"


@pytest.mark.parametrize("start", [0, 1, 42])
def test_ordered_start_is_preserved(tmp_path, start):
    enums = _query(tmp_path, f"{start}. First\n{start + 1}. Second\n", "enum")
    assert len(enums) == 1
    assert enums[0]["start"] == start
    assert enums[0]["tight"] is True
    assert len(enums[0]["children"]) == 2


@pytest.mark.parametrize("fenced", [True, False])
@pytest.mark.parametrize("custom", [True, False])
def test_code_is_literal_even_with_delimiters_and_controls(tmp_path, fenced, custom):
    content = '```\n#panic("code executed")\n] /* \\u0001\n\x01\b\f\tfin\n\n'
    language = 'odd"lang\\name'
    markdown = (
        f"~~~{language}\n{content}\n~~~\n" if fenced
        else "\n".join("    " + line for line in content.split("\n")) + "\n"
    )
    config = Config()
    prelude = ""
    if custom:
        config.code.block_function = "sourcecode"
        prelude = (
            "#let sourcecode(body, lang: none) = {\n"
            "  assert(body.func() == raw)\n"
            "  metadata(lang)\n"
            "  body\n"
            "}\n"
        )
    raws = _query(tmp_path, markdown, "raw", config=config, prelude=prelude)
    assert len(raws) == 1
    # Indented blocks discard trailing blank lines during Markdown parsing.
    expected = content if fenced else content.rstrip("\n")
    assert raws[0]["text"] == expected
    assert raws[0]["block"] is True
    if fenced and not custom:
        assert raws[0]["lang"] == language
    if custom:
        metadata = _query(tmp_path, markdown, "metadata", config=config, prelude=prelude)
        assert metadata[0]["value"] == (language if fenced else None)


@pytest.mark.parametrize("html", [
    '<!-- */ #panic("HTML executed") /* -->',
    '<div>*/ #panic("HTML executed") /*</div>',
    '<!-- /* unterminated Typst comment -->',
])
def test_ordinary_html_cannot_execute_or_break_typst(tmp_path, html):
    assert _query(tmp_path, html + "\n\nVisible\n", "metadata") == []


def test_special_html_directives_still_work(tmp_path):
    markdown = '''<!-- Table of contents -->

# Topic
<!-- Question: Q1 | Safe summary -->

<!-- Question index -->
'''
    assert len(_query(tmp_path, markdown, "outline")) == 1
    metadata = _query(tmp_path, markdown, "metadata")
    assert metadata[0]["value"] == {
        "kind": "mdtyp-question", "id": "Q1", "summary": "Safe summary",
    }
    headings = _query(tmp_path, markdown, "heading")
    assert any(_text(heading["body"]) == "Question index" for heading in headings)
