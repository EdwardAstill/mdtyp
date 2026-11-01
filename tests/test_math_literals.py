"""Text and command boundaries must survive the math translation pipeline."""

import json
import shutil
import subprocess

import pytest

from mdtyp.converter import convert
from mdtyp.latex2typst import latex_to_typst


@pytest.mark.parametrize("source, expected", [
    (r'\text{say "yes"}', 'say "yes"'),
    (r"\text{two  spaces}", "two  spaces"),
    (r"\text{value_{old}}", "value_old"),
    (r"\text{cost \$5 and 10\%}", "cost $5 and 10%"),
    (r"\text{set \{a, b\}}", "set {a, b}"),
    (r"\text {nested {groups} and \_}", "nested groups and _"),
])
def test_math_text_stays_literal(source, expected):
    assert json.loads(latex_to_typst(source)) == expected


@pytest.mark.parametrize("source", [
    r"\sinewave", r"\alphabet", r"\sqrtExtra{x}", r"\unknown{x}",
    r"\frac{x}", r"\text{unfinished",
])
def test_unknown_or_incomplete_commands_are_not_silently_rewritten(source):
    with pytest.raises(ValueError):
        latex_to_typst(source)


@pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")
def test_text_does_not_change_matrix_structure_or_fraction_content(tmp_path):
    source = tmp_path / "math.typ"
    source.write_text(convert(
        r'$$\begin{pmatrix}\text{A & B} & c \\ d & e\end{pmatrix}$$'
        '\n\n'
        r'$$\frac{\text{say "yes"}}{2}$$'
    ), encoding="utf-8")
    result = subprocess.run(
        ["typst", "query", str(source), "math.equation"], capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    matrix, fraction = (equation["body"] for equation in json.loads(result.stdout))
    assert [len(row) for row in matrix["rows"]] == [2, 2]
    assert matrix["rows"][0][0]["text"] == "A & B"
    assert fraction["num"]["text"] == 'say "yes"'


@pytest.mark.skipif(shutil.which("typst") is None, reason="Typst is not installed")
def test_math_symbol_names_render_the_intended_symbols(tmp_path):
    source = tmp_path / "symbols.typ"
    source.write_text(convert(
        r"$\partial$ $\oplus$ $\otimes$ $\hbar$ $\langle$ $\rangle$"
    ), encoding="utf-8")
    result = subprocess.run(
        ["typst", "query", str(source), "math.equation"], capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    assert [equation["body"]["text"] for equation in json.loads(result.stdout)] == [
        "∂", "⊕", "⊗", "ħ", "⟨", "⟩",
    ]
