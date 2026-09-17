"""Regression checks for printable statistics notes."""

import shutil
import subprocess

import pytest

from mdtyp.config import load_config
from mdtyp.converter import convert


def test_print_config(tmp_path):
    config_path = tmp_path / "print.toml"
    config_path.write_text(
        '[page]\nmargin = "15mm"\nnumbering = "1"\n'
        '[text]\nsize = "12pt"\n'
    )
    output = convert("# Notes", load_config(config_path))
    assert "#set page(margin: 15mm)" in output
    assert '#set page(numbering: "1")' in output
    assert "#set text(size: 12pt)" in output


@pytest.mark.skipif(not shutil.which("typst"), reason="Typst is not installed")
def test_statistics_math_compiles(tmp_path):
    source = r"""# Statistics

<!-- Table of contents -->

$$
A\cap B=\emptyset,\quad P(A\mid B),\quad \beta\ne1
$$

$$
\binom21\binom{18}{3},\quad \binom njp^j(1-p)^{n-j}
$$

$$
xf(x)+xp(x)+tf(t)+np(1-p)+aE(X)+bE(Y),\quad \frac{dR(t)}{dt}
$$

$$
\frac{12}{6{,}149{,}520},\quad \lfloor x\rfloor
$$
"""
    typ = tmp_path / "statistics.typ"
    typ.write_text(convert(source))
    result = subprocess.run(
        ["typst", "compile", str(typ)], capture_output=True, text=True
    )
    assert result.returncode == 0, result.stderr
    assert typ.with_suffix(".pdf").is_file()
