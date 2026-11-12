"""Translate LaTeX math expressions to Typst math syntax.

Pipeline stages (must run in this order — each assumes prior stages completed):

Text arguments are protected before these stages and serialized afterward.

1. **Environments** — ``\\begin{aligned}``, matrices, cases → Typst equivalents.
   Must run first because environments contain raw LaTeX that later stages process.
2. **Structured commands** — ``\\frac``, ``\\sqrt``, accents, font commands, ``\\mathbb``.
   Must run before simple replacements to avoid partial matches on inner braces.
3. **Simple symbol replacements** — ``_COMMANDS`` list (operators, Greek, arrows, …).
   Sorted longest-first to prevent partial matches.
4. **Script conversion** — ``_{...}`` → ``_(...)``, ``^{...}`` → ``^(...)``.
   Must run after commands so ``\\frac{a}{b}`` isn't mis-parsed as a superscript.
5. **Multi-character identifier quoting** — wraps unknown multi-letter identifiers
   in ``"..."`` since Typst math treats consecutive letters as separate variables.
"""

from __future__ import annotations

import re

from mdtyp.typst import typst_string

# ---------------------------------------------------------------------------
# LaTeX command → Typst replacement tables
# ---------------------------------------------------------------------------

_COMMANDS: list[tuple[str, str]] = [
    # --- Operators ---
    (r"\cdot", "dot"),
    (r"\times", "times"),
    (r"\div", "div"),
    (r"\pm", "plus.minus"),
    (r"\mp", "minus.plus"),
    (r"\circ", "compose"),
    (r"\ast", "ast"),
    (r"\star", "star"),
    (r"\oplus", "plus.o"),
    (r"\otimes", "times.o"),

    # --- Relations ---
    (r"\leq", "<="),
    (r"\le", "<="),
    (r"\geq", ">="),
    (r"\ge", ">="),
    (r"\neq", "!="),
    (r"\ne", "!="),
    (r"\mid", "|"),
    (r"\approx", "approx"),
    (r"\equiv", "equiv"),
    (r"\sim", "tilde.op"),
    (r"\propto", "prop"),
    (r"\ll", "<<"),
    (r"\gg", ">>"),
    (r"\subset", "subset"),
    (r"\supset", "supset"),
    (r"\subseteq", "subset.eq"),
    (r"\supseteq", "supset.eq"),
    (r"\in", "in"),
    (r"\notin", "in.not"),
    (r"\ni", "in.rev"),

    # --- Escaped characters ---
    (r"\%", "%"),

    # --- Arrows ---
    (r"\implies", "=>"),
    (r"\iff", "<=>"),
    (r"\to", "->"),
    (r"\rightarrow", "->"),
    (r"\leftarrow", "<-"),
    (r"\leftrightarrow", "<->"),
    (r"\Rightarrow", "=>"),
    (r"\Leftarrow", "arrow.l.double"),
    (r"\Leftrightarrow", "<=>"),
    (r"\mapsto", "|->"),
    (r"\uparrow", "arrow.t"),
    (r"\downarrow", "arrow.b"),

    # --- Big operators ---
    (r"\int", "integral"),
    (r"\iint", "integral.double"),
    (r"\iiint", "integral.triple"),
    (r"\oint", "integral.cont"),
    (r"\sum", "sum"),
    (r"\prod", "product"),
    (r"\coprod", "product.co"),
    (r"\bigcup", "union.big"),
    (r"\bigcap", "inter.big"),

    # --- Functions (limits, log, trig, etc.) ---
    (r"\lim", "lim"),
    (r"\sup", "sup"),
    (r"\inf", "inf"),
    (r"\min", "min"),
    (r"\max", "max"),
    (r"\log", "log"),
    (r"\ln", "ln"),
    (r"\exp", "exp"),
    (r"\sin", "sin"),
    (r"\cos", "cos"),
    (r"\tan", "tan"),
    (r"\sec", "sec"),
    (r"\csc", "csc"),
    (r"\cot", "cot"),
    (r"\arcsin", "arcsin"),
    (r"\arccos", "arccos"),
    (r"\arctan", "arctan"),
    (r"\sinh", "sinh"),
    (r"\cosh", "cosh"),
    (r"\tanh", "tanh"),
    (r"\det", "det"),
    (r"\dim", "dim"),
    (r"\ker", "ker"),
    (r"\deg", "deg"),
    (r"\arg", "arg"),
    (r"\gcd", "gcd"),
    (r"\mod", "mod"),

    # --- Currency ---
    (r"\pounds", "£"),
    (r"\euro", "€"),
    (r"\yen", "¥"),

    # --- Misc symbols ---
    (r"\infty", "infinity"),
    (r"\partial", "partial"),
    (r"\nabla", "nabla"),
    (r"\forall", "forall"),
    (r"\exists", "exists"),
    (r"\neg", "not"),
    (r"\land", "and"),
    (r"\lor", "or"),
    (r"\cup", "union"),
    (r"\cap", "inter"),
    (r"\emptyset", "emptyset"),
    (r"\varnothing", "emptyset"),
    (r"\ldots", "dots"),
    (r"\cdots", "dots.c"),
    (r"\vdots", "dots.v"),
    (r"\ddots", "dots.down"),
    (r"\dots", "dots"),
    (r"\ell", "ell"),
    (r"\hbar", "planck"),
    (r"\Re", "Re"),
    (r"\Im", "Im"),
    (r"\aleph", "aleph"),

    # --- Delimiters (sizing commands just removed) ---
    (r"\left(", "("),
    (r"\right)", ")"),
    (r"\left[", "["),
    (r"\right]", "]"),
    (r"\left\{", "{"),
    (r"\right\}", "}"),
    (r"\left|", "|"),
    (r"\right|", "|"),
    (r"\left.", ""),
    (r"\right.", ""),
    (r"\langle", "chevron.l"),
    (r"\rangle", "chevron.r"),
    (r"\lfloor", "floor.l"),
    (r"\rfloor", "floor.r"),
    (r"\lceil", "ceil.l"),
    (r"\rceil", "ceil.r"),
    (r"\{", "{"),
    (r"\}", "}"),
    (r"\|", "||"),

    # --- Accents / decorations (handled as simple replacements only when
    #     they appear without braces; braced forms like \overline{x} are
    #     handled by _translate_commands as structured one-arg commands) ---
    (r"\overline", "overline"),
    (r"\underline", "underline"),

    # --- Spacing ---
    (r"\quad", "quad"),
    (r"\qquad", "wide"),
    (r"\,", "thin"),
    (r"\;", "med"),
    (r"\!", ""),

    # --- Greek lowercase ---
    (r"\alpha", "alpha"),
    (r"\beta", "beta"),
    (r"\gamma", "gamma"),
    (r"\delta", "delta"),
    (r"\epsilon", "epsilon"),
    (r"\varepsilon", "epsilon.alt"),
    (r"\zeta", "zeta"),
    (r"\eta", "eta"),
    (r"\theta", "theta"),
    (r"\vartheta", "theta.alt"),
    (r"\iota", "iota"),
    (r"\kappa", "kappa"),
    (r"\lambda", "lambda"),
    (r"\mu", "mu"),
    (r"\nu", "nu"),
    (r"\xi", "xi"),
    (r"\pi", "pi"),
    (r"\varpi", "pi.alt"),
    (r"\rho", "rho"),
    (r"\varrho", "rho.alt"),
    (r"\sigma", "sigma"),
    (r"\varsigma", "sigma.alt"),
    (r"\tau", "tau"),
    (r"\upsilon", "upsilon"),
    (r"\phi", "phi.alt"),
    (r"\varphi", "phi"),
    (r"\chi", "chi"),
    (r"\psi", "psi"),
    (r"\omega", "omega"),

    # --- Greek uppercase ---
    (r"\Gamma", "Gamma"),
    (r"\Delta", "Delta"),
    (r"\Theta", "Theta"),
    (r"\Lambda", "Lambda"),
    (r"\Xi", "Xi"),
    (r"\Pi", "Pi"),
    (r"\Sigma", "Sigma"),
    (r"\Upsilon", "Upsilon"),
    (r"\Phi", "Phi"),
    (r"\Psi", "Psi"),
    (r"\Omega", "Omega"),
]

# Precompile: sorted longest-first to prevent partial matches, with compiled regex.
_COMPILED_COMMANDS: list[tuple[re.Pattern[str], str]] = [
    (re.compile(re.escape(cmd) + (r"(?![A-Za-z])" if cmd[-1].isalpha() else "")), rep)
    for cmd, rep in sorted(_COMMANDS, key=lambda x: -len(x[0]))
]

# Blackboard bold: \mathbb{X} → XX
_MATHBB: dict[str, str] = {
    "R": "RR", "N": "NN", "Z": "ZZ", "Q": "QQ", "C": "CC",
    "F": "FF", "P": "PP", "E": "EE", "1": "bb(1)",
}

# ---------------------------------------------------------------------------
# Precompiled environment patterns
# ---------------------------------------------------------------------------

_RE_ALIGNED = re.compile(
    r"\\begin\{(aligned|align\*?)\}(.*?)\\end\{\1\}", re.DOTALL,
)
_RE_CASES = re.compile(
    r"\\begin\{cases\}(.*?)\\end\{cases\}", re.DOTALL,
)
_MATRIX_DELIMS: dict[str, str] = {
    "pmatrix": '"("',
    "bmatrix": '"["',
    "Bmatrix": '"{"',
    "vmatrix": '"|"',
    "Vmatrix": '"||"',
    "matrix": '"("',
}
_RE_MATRICES: list[tuple[re.Pattern[str], str]] = [
    (re.compile(rf"\\begin\{{{env}\}}(.*?)\\end\{{{env}\}}", re.DOTALL), delim)
    for env, delim in _MATRIX_DELIMS.items()
]

_RE_TEXT = re.compile(r"\\text(?![A-Za-z])\s*\{")
_RE_MATHBB = re.compile(r"\\mathbb\{([^}]*)\}")
_RE_SQRT = re.compile(r"\\sqrt(?![A-Za-z])")
_RE_MULTI_SPACE = re.compile(r"  +")

# \not + following symbol → negated Typst symbol (longest-first to avoid partial matches)
_NOT_MAP: list[tuple[str, str]] = sorted([
    (r"\Leftrightarrow", "arrow.lr.double.not"),
    (r"\Rightarrow", "arrow.r.double.not"),
    (r"\Leftarrow", "arrow.l.double.not"),
    (r"\subseteq", "subset.eq.not"),
    (r"\supseteq", "supset.eq.not"),
    (r"\implies", "arrow.r.double.not"),
    (r"\subset", "subset.not"),
    (r"\supset", "supset.not"),
    (r"\equiv", "eq.not"),
    (r"\leq", "lt.eq.not"),
    (r"\geq", "gt.eq.not"),
    (r"\iff", "arrow.lr.double.not"),
    (r"\in", "in.not"),
    ("=", "eq.not"),
    ("<", "lt.not"),
    (">", "gt.not"),
], key=lambda x: -len(x[0]))
_NOT_ALTS = "|".join(
    re.escape(sym) + (r"(?![A-Za-z])" if sym[-1].isalpha() else "")
    for sym, _ in _NOT_MAP
)
_RE_NOT = re.compile(rf"\\not\s*({_NOT_ALTS})|\\not\b")
_NOT_LOOKUP: dict[str, str] = dict(_NOT_MAP)

# Known Typst math identifiers that must NOT be quoted.
_TYPST_MATH_IDENTS: frozenset[str] = frozenset({
    # Typst math functions
    "frac", "sqrt", "root", "binom", "boxed",
    "hat", "macron", "arrow", "diaer", "tilde",
    "overline", "underline", "overbrace", "underbrace",
    "upright", "bold", "italic", "cal", "op", "bb",
    "mat", "cases", "delim",
    "nothing",
} | {
    replacement.split(".", 1)[0]
    for _, replacement in _COMMANDS + _NOT_MAP
    if replacement[:1].isalpha()
} | {replacement for replacement in _MATHBB.values() if replacement.isidentifier()})


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------


def latex_to_typst(latex: str) -> str:
    """Convert a LaTeX math string to Typst math syntax."""
    s, text_literals = _protect_text(latex.strip())
    s = _translate_environments(s)
    s = _translate_commands(s)
    if unknown := re.search(r"\\[A-Za-z]+", s):
        raise ValueError(f"Unsupported or malformed LaTeX command: {unknown.group()}")
    s = _translate_scripts(s)
    s = _quote_multichar_identifiers(s)
    s = _RE_MULTI_SPACE.sub(" ", s)
    return s.translate(text_literals).strip()


def _protect_text(s: str) -> tuple[str, dict[int, str]]:
    """Keep text opaque to every math stage, including environment splitting."""
    parts: list[str] = []
    literals: dict[int, str] = {}
    pos = 0
    marker = 0xF0000
    while match := _RE_TEXT.search(s, pos):
        text, end = _extract_braced(s, match.end() - 1)
        if text is None:
            raise ValueError("Unclosed LaTeX text argument")
        while chr(marker) in s:
            marker += 1
        # Private-use characters are single math atoms, never identifier letters.
        parts.extend((s[pos:match.start()], chr(marker)))
        text = re.sub(r"\\([#$%&_{}\\])|[{}]", lambda m: m[1] or "", text)
        literals[marker] = typst_string(text)
        marker += 1
        pos = end
    parts.append(s[pos:])
    return "".join(parts), literals


# ---------------------------------------------------------------------------
# Stage 1: Environments
# ---------------------------------------------------------------------------


def _translate_environments(s: str) -> str:
    """Replace LaTeX environments (aligned, cases, matrices) with Typst equivalents.

    Must run first: environments contain raw LaTeX that later stages will process.
    """
    s = _RE_ALIGNED.sub(lambda m: _pad_math_replacement(m, _convert_aligned(m.group(2))), s)
    s = _RE_CASES.sub(lambda m: _pad_math_replacement(m, _convert_cases(m.group(1))), s)
    for pattern, delim in _RE_MATRICES:
        s = pattern.sub(
            lambda m, d=delim: _pad_math_replacement(m, _convert_matrix(m.group(1), d)),
            s,
        )
    return s


def _pad_math_replacement(m: re.Match[str], replacement: str) -> str:
    """Add spaces when replacing an environment adjacent to math atoms."""
    before = " " if m.start() > 0 and _needs_math_space(m.string[m.start() - 1]) else ""
    after = " " if m.end() < len(m.string) and _needs_math_space(m.string[m.end()]) else ""
    return before + replacement + after


def _needs_math_space(ch: str) -> bool:
    return ch.isalnum() or ch in "_)}]"


def _split_latex_rows(body: str) -> list[str]:
    """Split matrix/alignment rows on LaTeX row breaks.

    Accepts both proper ``\\\\`` separators and a common Markdown typo where a
    single trailing backslash before a newline is used as the row separator.
    """
    rows: list[str] = []
    buf: list[str] = []
    i = 0

    def flush() -> None:
        row = "".join(buf).strip()
        if row:
            rows.append(row)
        buf.clear()

    while i < len(body):
        ch = body[i]
        if ch == "\\":
            if i + 1 < len(body) and body[i + 1] == "\\":
                flush()
                i += 2
                while i < len(body) and body[i] in " \t\r\n":
                    i += 1
                continue
            j = i + 1
            while j < len(body) and body[j] in " \t\r":
                j += 1
            if j == len(body) or body[j] == "\n":
                flush()
                i = j + 1 if j < len(body) else j
                continue
        buf.append(ch)
        i += 1
    flush()

    if len(rows) == 1 and "\n" in rows[0]:
        line_rows = [line.strip() for line in rows[0].splitlines() if line.strip()]
        if len(line_rows) > 1:
            return line_rows
    return rows


def _convert_aligned(body: str) -> str:
    converted = []
    for line in _split_latex_rows(body):
        line = line.strip()
        if line:
            line = line.replace("&", "")
            converted.append(line)
    return " \\\n".join(converted)


def _convert_cases(body: str) -> str:
    parts = []
    for line in _split_latex_rows(body):
        line = line.strip()
        if line:
            chunks = line.split("&")
            val = chunks[0].strip()
            cond = chunks[1].strip() if len(chunks) > 1 else ""
            if cond:
                parts.append(f"  {val} & {cond}")
            else:
                parts.append(f"  {val}")
    return "cases(\n" + ",\n".join(parts) + "\n)"


def _convert_matrix(body: str, delim: str) -> str:
    row_strs = []
    for row in _split_latex_rows(body):
        row = row.strip()
        if row:
            cells = [c.strip() for c in row.split("&")]
            row_strs.append(", ".join(cells))
    return f"mat(delim: {delim}, {'; '.join(row_strs)})"


# ---------------------------------------------------------------------------
# Stage 2 & 3: Structured + simple command replacements
# ---------------------------------------------------------------------------


def _translate_commands(s: str) -> str:
    """Replace LaTeX commands with Typst equivalents.

    Structured commands (``\\frac``, ``\\sqrt``, accents, font commands) are
    handled first because they consume brace-delimited arguments.  Simple
    symbol replacements follow, sorted longest-first to prevent partial matches.
    """
    # Passthrough: \boxed{x} → x
    s = _replace_cmd_passthrough(s, "boxed")

    # Two-arg commands: \frac{a}{b} → frac(a, b)
    for latex_name, typst_name in [
        ("frac", "frac"), ("dfrac", "frac"), ("tfrac", "frac"), ("binom", "binom"),
    ]:
        s = _replace_cmd_two_args(s, latex_name, typst_name)
    for latex_name, typst_name in [
        ("frac", "frac"), ("dfrac", "frac"), ("tfrac", "frac"),
        ("binom", "binom"),
    ]:
        s = _replace_cmd_two_bare_atoms(s, latex_name, typst_name)

    # Square root: \sqrt[n]{x} → root(n, x), \sqrt{x} → sqrt(x)
    s = _replace_sqrt(s)

    # One-arg accent/decoration commands
    accent_commands = [
        ("hat", "hat"), ("bar", "macron"), ("vec", "arrow"),
        ("dot", "dot"), ("ddot", "diaer"), ("tilde", "tilde"),
        ("overline", "overline"), ("underline", "underline"),
        ("overbrace", "overbrace"), ("underbrace", "underbrace"),
    ]
    for latex_name, typst_name in accent_commands:
        s = _replace_cmd_one_arg(s, latex_name, typst_name)
    for latex_name, typst_name in accent_commands:
        s = _replace_cmd_bare_atom(s, latex_name, typst_name)

    # Extensible arrows: \xrightarrow{N} → arrow.r^(N)
    s = _replace_cmd_one_arg_template(s, "xrightarrow", "arrow.r^({arg})")
    s = _replace_cmd_one_arg_template(s, "xleftarrow", "arrow.l^({arg})")

    # Font commands
    for latex_name, typst_name in [
        ("mathrm", "upright"), ("operatorname", "op"),
        ("mathbf", "bold"), ("boldsymbol", "bold"),
        ("mathit", "italic"), ("mathcal", "cal"),
    ]:
        s = _replace_cmd_one_arg(s, latex_name, typst_name)

    # \mathbb{X} → XX or bb(X)
    s = _RE_MATHBB.sub(
        lambda m: _pad_command_replacement(
            s, m.start(), m.end(), _MATHBB.get(m.group(1), f"bb({m.group(1)})"),
        ), s,
    )

    # Quote thousands separators so commas cannot become function arguments.
    s = s.replace("{,}", '","')

    # \not + following symbol (must run before simple commands so \not\Rightarrow
    # is handled before \Rightarrow gets converted to =>)
    s = _translate_not(s)

    # Simple command replacements (precompiled, longest-first)
    for pattern, typst_rep in _COMPILED_COMMANDS:
        s = _replace_with_spacing(s, pattern, typst_rep)

    return s


# ---------------------------------------------------------------------------
# Command replacement helpers
# ---------------------------------------------------------------------------


def _pad_command_replacement(s: str, start: int, end: int, replacement: str) -> str:
    """Keep replacements from joining adjacent commands or identifiers."""
    before = " " if start > 0 and s[start - 1].isalnum() else ""
    after = " " if end < len(s) and s[end].isalnum() else ""
    return before + replacement + after


def _replace_with_spacing(
    s: str, pattern: re.Pattern[str], typst_rep: str,
) -> str:
    """Replace a LaTeX command, adding spaces to prevent identifier merging."""
    return pattern.sub(
        lambda m: _pad_command_replacement(s, m.start(), m.end(), typst_rep), s,
    )


def _replace_cmd_passthrough(s: str, latex_name: str) -> str:
    """Replace ``\\cmd{arg}`` → ``arg`` (strip the command wrapper)."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        arg, end = _extract_braced(s, m.end() - 1)
        if arg is None:
            break
        s = s[: m.start()] + _pad_command_replacement(s, m.start(), end, arg) + s[end:]
    return s


def _replace_cmd_one_arg(s: str, latex_name: str, typst_name: str) -> str:
    """Replace ``\\cmd{arg}`` → ``typst_name(arg)``."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        start = m.start()
        arg, end = _extract_braced(s, m.end() - 1)
        if arg is None:
            break
        s = s[:start] + _pad_command_replacement(
            s, start, end, f"{typst_name}({arg})",
        ) + s[end:]
    return s


def _replace_cmd_one_arg_template(s: str, latex_name: str, template: str) -> str:
    """Replace ``\\cmd{arg}`` using a format template containing ``{arg}``."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        start = m.start()
        arg, end = _extract_braced(s, m.end() - 1)
        if arg is None:
            break
        s = s[:start] + _pad_command_replacement(
            s, start, end, template.format(arg=arg),
        ) + s[end:]
    return s


def _replace_cmd_bare_atom(s: str, latex_name: str, typst_name: str) -> str:
    """Replace ``\\cmd x`` → ``typst_name(x)`` for accent-style commands."""
    pattern = re.compile(rf"\\{latex_name}(?![A-Za-z])")
    while (m := pattern.search(s)):
        start = m.start()
        atom, end = _extract_math_atom(s, m.end())
        if atom is None:
            break
        s = s[:start] + _pad_command_replacement(
            s, start, end, f"{typst_name}({atom})",
        ) + s[end:]
    return s


def _extract_math_atom(s: str, pos: int) -> tuple[str | None, int]:
    """Extract the next simple LaTeX math atom, including attached scripts."""
    while pos < len(s) and s[pos].isspace():
        pos += 1
    if pos >= len(s):
        return None, pos
    if s[pos] == "{":
        atom, end = _extract_braced(s, pos)
        if atom is None:
            return None, pos
        return atom, end
    end = _consume_math_atom_head(s, pos)
    if end == pos:
        return None, pos
    end = _consume_attached_scripts(s, end)
    return s[pos:end], end


def _consume_math_atom_head(s: str, pos: int) -> int:
    if pos >= len(s):
        return pos
    if s[pos] == "\\":
        j = pos + 1
        while j < len(s) and s[j].isalpha():
            j += 1
        return j if j > pos + 1 else min(pos + 2, len(s))
    if s[pos].isalpha():
        j = pos
        while j < len(s) and s[j].isalnum():
            j += 1
        word = s[pos:j]
        if word in _TYPST_MATH_IDENTS:
            while j < len(s) and s[j] == ".":
                k = j + 1
                while k < len(s) and s[k].isalpha():
                    k += 1
                if k == j + 1:
                    break
                j = k
            return j
    return pos + 1


def _consume_attached_scripts(s: str, pos: int) -> int:
    while pos < len(s) and s[pos] in ("_", "^"):
        pos += 1
        if pos >= len(s):
            break
        if s[pos] == "{":
            _, end = _extract_braced(s, pos)
            if end == pos:
                break
            pos = end
        else:
            pos = _consume_math_atom_head(s, pos)
    return pos


def _replace_cmd_two_args(s: str, latex_name: str, typst_name: str) -> str:
    """Replace ``\\cmd{a}{b}`` → ``typst_name(a, b)``."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        start = m.start()
        arg1, after1 = _extract_braced(s, m.end() - 1)
        if arg1 is None:
            break
        arg2, after2 = _extract_braced(s, after1)
        if arg2 is None:
            break
        s = s[:start] + _pad_command_replacement(
            s, start, after2, f"{typst_name}({arg1}, {arg2})",
        ) + s[after2:]
    return s


def _replace_cmd_two_bare_atoms(s: str, latex_name: str, typst_name: str) -> str:
    """Replace compact two-atom commands like ``\\frac12`` → ``frac(1, 2)``."""
    pattern = re.compile(rf"\\{latex_name}(?![A-Za-z])")
    while (m := pattern.search(s)):
        start = m.start()
        arg1, after1 = _extract_math_atom(s, m.end())
        if arg1 is None:
            break
        arg2, after2 = _extract_math_atom(s, after1)
        if arg2 is None:
            break
        s = s[:start] + _pad_command_replacement(
            s, start, after2, f"{typst_name}({arg1}, {arg2})",
        ) + s[after2:]
    return s


def _replace_sqrt(s: str) -> str:
    """Replace ``\\sqrt[n]{x}`` → ``root(n, x)`` and ``\\sqrt{x}`` → ``sqrt(x)``."""
    while (m := _RE_SQRT.search(s)):
        pos = m.end()
        if pos < len(s) and s[pos] == "[":
            bracket_end = s.find("]", pos)
            if bracket_end == -1:
                break
            n_arg = s[pos + 1 : bracket_end]
            arg, after = _extract_braced(s, bracket_end + 1)
            if arg is None:
                break
            replacement = f"root({n_arg}, {arg})"
        elif pos < len(s) and s[pos] == "{":
            arg, after = _extract_braced(s, pos)
            if arg is None:
                break
            replacement = f"sqrt({arg})"
        else:
            arg, after = _extract_math_atom(s, pos)
            if arg is None:
                break
            replacement = f"sqrt({arg})"
        s = s[: m.start()] + _pad_command_replacement(
            s, m.start(), after, replacement,
        ) + s[after:]
    return s


def _extract_braced(s: str, pos: int) -> tuple[str | None, int]:
    """Extract content from balanced braces starting at *pos*.

    Returns ``(content, end_pos)`` on success or ``(None, pos)`` on failure.
    """
    while pos < len(s) and s[pos] == " ":
        pos += 1
    if pos >= len(s) or s[pos] != "{":
        return None, pos
    depth = 0
    start = pos + 1
    i = pos
    while i < len(s):
        if s[i] == "\\" and i + 1 < len(s) and s[i + 1] in "{}":
            i += 2
            continue
        if s[i] == "{":
            depth += 1
        elif s[i] == "}":
            depth -= 1
            if depth == 0:
                return s[start:i], i + 1
        i += 1
    return None, pos


def _translate_not(s: str) -> str:
    """Replace ``\\not X`` with negated Typst symbol, or bare ``not`` as fallback."""
    def _replace(m: re.Match[str]) -> str:
        sym = m.group(1)
        replacement = _NOT_LOOKUP[sym] if sym is not None else "not"
        return _pad_command_replacement(s, m.start(), m.end(), replacement)
    return _RE_NOT.sub(_replace, s)


# ---------------------------------------------------------------------------
# Stage 4: Script conversion
# ---------------------------------------------------------------------------

_RE_BARE_STAR_SUPER = re.compile(r"\^\*")


def _translate_scripts(s: str) -> str:
    """Convert LaTeX brace-grouped sub/superscripts: ``_{...}`` → ``_(...)``."""
    # An empty LaTeX base supports standalone unit exponents, e.g. m${}^3$.
    s = re.sub(r"\{\}(?=[_^])", '""', s)
    # Bare ^* → ^ast: prevents */ from being parsed as a Typst block comment end.
    s = _RE_BARE_STAR_SUPER.sub("^ast", s)
    result: list[str] = []
    i = 0
    while i < len(s):
        if i < len(s) - 1 and s[i] in ("_", "^"):
            marker = s[i]
            if s[i + 1] == "{":
                content, end = _extract_braced(s, i + 1)
                if content is not None:
                    result.append(f"{marker}({content})")
                    i = end
                    continue
            elif s[i + 1] != "(":
                end = _consume_math_atom_head(s, i + 1)
                if end > i + 1:
                    result.append(s[i:end])
                    i = end
                    if i < len(s) and (s[i].isalnum() or s[i] == "\\"):
                        result.append(" ")
                    continue
        result.append(s[i])
        i += 1
    return "".join(result)


# ---------------------------------------------------------------------------
# Stage 5: Multi-character identifier quoting
# ---------------------------------------------------------------------------


def _quote_multichar_identifiers(s: str) -> str:
    """Wrap multi-letter identifiers not known to Typst math in double quotes.

    In Typst math mode consecutive letters like ``EX`` are parsed as separate
    multiplied variables.  Unknown multi-letter names must be quoted so they
    render as a single identifier.
    """
    result: list[str] = []
    i = 0
    while i < len(s):
        # Pass already-quoted strings through unchanged.
        if s[i] == '"':
            j = i + 1
            while j < len(s) and s[j] != '"':
                j += 1
            result.append(s[i : j + 1])
            i = j + 1
            continue
        # Collect an identifier-like run beginning with a letter.
        if s[i].isalpha():
            j = i
            while j < len(s) and s[j].isalnum():
                j += 1
            word = s[i:j]
            # Skip whitespace, then check whether a '(' follows (function call).
            k = j
            while k < len(s) and s[k] == " ":
                k += 1
            is_func_call = k < len(s) and s[k] == "("
            # Don't quote modifiers after a dot (e.g. subset.eq, in.not)
            is_dot_modifier = i > 0 and s[i - 1] == "."
            if (
                len(word) >= 2
                and word not in _TYPST_MATH_IDENTS
                and not is_dot_modifier
            ):
                if is_func_call and word.isalpha():
                    # Unmarked LaTeX letters are multiplied variables, including
                    # products immediately before a parenthesized expression.
                    result.append(" ".join(word))
                else:
                    result.append(f'"{word}"')
            else:
                result.append(word)
            i = j
            continue
        result.append(s[i])
        i += 1
    return "".join(result)
