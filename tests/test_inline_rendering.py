"""Consumer-visible inline safety and structure checks against Typst itself."""

import json
import shutil
import subprocess

import pytest

from mdtyp.converter import convert
from mdtyp.typst import typst_string


pytestmark = pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")


def _query(path):
    result = subprocess.run(
        ["typst", "query", str(path), "<result>", "--field", "value", "--one"],
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    return json.loads(result.stdout)


def _content(tmp_path, markdown):
    rendered = convert(markdown)
    path = tmp_path / "document.typ"
    path.write_text(rendered + "\n#metadata([" + rendered + "]) <result>", encoding="utf-8")
    result = subprocess.run(
        ["typst", "compile", str(path), str(path.with_suffix(".pdf"))],
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    return _query(path)


def _nodes(value):
    if isinstance(value, dict):
        yield value
        for child in value.values():
            yield from _nodes(child)
    elif isinstance(value, list):
        for child in value:
            yield from _nodes(child)


def _text(value):
    if "text" in value:
        return value["text"]
    if value.get("func") == "space":
        return " "
    if value.get("func") == "parbreak":
        return "\n\n"
    if "child" in value:
        return _text(value["child"])
    if "body" in value:
        return _text(value["body"])
    return "".join(_text(child) for child in value.get("children", []))


@pytest.mark.parametrize("value", [
    "".join(chr(code) for code in range(32)),
    r'\u0001\b\f\\u0002\"',
    'é😀 "quoted" \\ end',
])
def test_typst_strings_preserve_controls_and_literal_escape_sequences(tmp_path, value):
    path = tmp_path / "string.typ"
    path.write_text(f"#metadata({typst_string(value)}) <result>", encoding="utf-8")
    assert _query(path) == value


def test_text_keeps_typst_punctuation_comments_and_line_markers_literal(tmp_path):
    markdown = (
        r'\[literal\] and \`tick\` // visible /* visible */ #panic("injected")'
        "\n\n= not a heading\n\n/ not a term\n\n"
        r'\+ not a list'
        "\n\n"
        r'\- not a list'
        "\n\n"
        r'1\. not a list'
    )
    content = _content(tmp_path, markdown)
    assert _text(content).strip() == (
        '[literal] and `tick` // visible /* visible */ #panic("injected")'
        "\n\n= not a heading\n\n/ not a term\n\n+ not a list"
        "\n\n- not a list\n\n1. not a list"
    )
    assert not any(node.get("func") in {"heading", "item", "raw"} for node in _nodes(content))


def test_inline_code_and_html_cannot_execute_typst(tmp_path):
    content = _content(
        tmp_path,
        '``a ` #panic("injected") ` b`` before <!-- */ #panic("injected") /* --> after',
    )
    raw = next(node for node in _nodes(content) if node.get("func") == "raw")
    assert raw["text"] == 'a ` #panic("injected") ` b'
    assert _text(content).strip() == 'a ` #panic("injected") ` b before after'


def test_nested_formatting_keeps_matching_scopes_and_siblings(tmp_path):
    content = _content(tmp_path, '*outer **bold *inner* tail** after* end')
    assert _text(content).strip() == "outer bold inner tail after end"
    assert [
        (node["func"], _text(node))
        for node in _nodes(content) if node.get("func") in {"strong", "emph"}
    ] == [
        ("emph", "outer bold inner tail after"),
        ("strong", "bold inner tail"),
        ("emph", "inner"),
    ]


def test_image_caption_and_escaped_local_destination_are_literal(tmp_path):
    (tmp_path / 'a "b".svg').write_text(
        '<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1">'
        '<rect width="1" height="1"/></svg>', encoding="utf-8",
    )
    content = _content(
        tmp_path,
        '![*caption* \\] #panic("injected") \\[ `literal` \\\\](<a "b".svg>)',
    )
    image = next(node for node in _nodes(content) if node.get("func") == "image")
    caption = next(node for node in _nodes(content) if node.get("func") == "caption")
    assert image["source"] == 'a "b".svg'
    assert _text(caption) == 'caption ] #panic("injected") [ literal \\'
    assert not any(node.get("func") in {"strong", "emph", "raw"} for node in _nodes(caption))


def test_link_label_and_url_are_preserved_without_code_evaluation(tmp_path):
    content = _content(
        tmp_path,
        '[label \\] #panic("injected") \\[](<https://example.com/"quoted"/a\\b>)',
    )
    link = next(node for node in _nodes(content) if node.get("func") == "link")
    assert link["dest"] == "https://example.com/%22quoted%22/a%5Cb"
    assert _text(link) == 'label ] #panic("injected") ['
