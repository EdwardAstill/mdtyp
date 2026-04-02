"""Translate LaTeX math expressions to Typst math syntax.

Pipeline stages (must run in this order — each assumes prior stages completed):

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
    (r"\oplus", "plus.circle"),
    (r"\otimes", "times.circle"),

    # --- Relations ---
    (r"\leq", "<="),
    (r"\geq", ">="),
    (r"\neq", "!="),
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
    (r"\bigcap", "sect.big"),

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
    (r"\partial", "diff"),
    (r"\nabla", "nabla"),
    (r"\forall", "forall"),
    (r"\exists", "exists"),
    (r"\neg", "not"),
    (r"\land", "and"),
    (r"\lor", "or"),
    (r"\cup", "union"),
    (r"\cap", "sect"),
    (r"\emptyset", "nothing"),
    (r"\varnothing", "nothing"),
    (r"\ldots", "dots"),
    (r"\cdots", "dots.c"),
    (r"\vdots", "dots.v"),
    (r"\ddots", "dots.down"),
    (r"\dots", "dots"),
    (r"\ell", "ell"),
    (r"\hbar", "planck.reduce"),
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
    (r"\langle", "angle.l"),
    (r"\rangle", "angle.r"),
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
    (re.compile(re.escape(cmd)), rep)
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
    "vmatrix": '"|"',
    "matrix": '"("',
}
_RE_MATRICES: list[tuple[re.Pattern[str], str]] = [
    (re.compile(rf"\\begin\{{{env}\}}(.*?)\\end\{{{env}\}}", re.DOTALL), delim)
    for env, delim in _MATRIX_DELIMS.items()
]

_RE_TEXT = re.compile(r"\\text\{([^}]*)\}")
_RE_MATHBB = re.compile(r"\\mathbb\{([^}]*)\}")
_RE_SQRT = re.compile(r"\\sqrt")
_RE_MULTI_SPACE = re.compile(r"  +")

# Known Typst math identifiers that must NOT be quoted.
_TYPST_MATH_IDENTS: frozenset[str] = frozenset({
    # Typst math functions
    "frac", "sqrt", "root", "binom", "boxed",
    "hat", "macron", "arrow", "diaer", "tilde",
    "overline", "underline", "overbrace", "underbrace",
    "upright", "bold", "italic", "cal", "op", "bb",
    "mat", "cases", "delim",
    # Math operator functions
    "lim", "sup", "inf", "min", "max",
    "log", "ln", "exp",
    "sin", "cos", "tan", "sec", "csc", "cot",
    "arcsin", "arccos", "arctan",
    "sinh", "cosh", "tanh",
    "det", "dim", "ker", "deg", "arg", "gcd", "mod",
    # Symbols
    "dot", "times", "div", "compose", "ast", "star",
    "approx", "equiv", "prop",
    "subset", "supset",
    "forall", "exists",
    "sum", "product", "integral",
    "union", "sect",
    "nabla", "infinity", "diff", "ell", "aleph", "nothing",
    "dots", "quad", "wide", "thin", "med",
    "Re", "Im",
    "and", "or", "not", "in",
    "plus", "minus",
    # Greek lowercase
    "alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta",
    "iota", "kappa", "lambda", "mu", "nu", "xi", "pi", "rho", "sigma",
    "tau", "upsilon", "phi", "chi", "psi", "omega",
    # Greek uppercase
    "Gamma", "Delta", "Theta", "Lambda", "Xi", "Pi", "Sigma", "Upsilon",
    "Phi", "Psi", "Omega",
    # Blackboard bold
    "RR", "NN", "ZZ", "QQ", "CC", "FF", "PP", "EE",
})


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------


def latex_to_typst(latex: str) -> str:
    """Convert a LaTeX math string to Typst math syntax."""
    s = latex.strip()
    s = _translate_environments(s)
    s = _translate_commands(s)
    s = _translate_scripts(s)
    s = _quote_multichar_identifiers(s)
    s = _RE_MULTI_SPACE.sub(" ", s)
    return s.strip()


# ---------------------------------------------------------------------------
# Stage 1: Environments
# ---------------------------------------------------------------------------


def _translate_environments(s: str) -> str:
    """Replace LaTeX environments (aligned, cases, matrices) with Typst equivalents.

    Must run first: environments contain raw LaTeX that later stages will process.
    """
    s = _RE_ALIGNED.sub(lambda m: _convert_aligned(m.group(2)), s)
    s = _RE_CASES.sub(lambda m: _convert_cases(m.group(1)), s)
    for pattern, delim in _RE_MATRICES:
        s = pattern.sub(lambda m, d=delim: _convert_matrix(m.group(1), d), s)
    return s


def _convert_aligned(body: str) -> str:
    lines = body.strip().split(r"\\")
    converted = []
    for line in lines:
        line = line.strip()
        if line:
            line = line.replace("&", "")
            converted.append(line)
    return " \\\n".join(converted)


def _convert_cases(body: str) -> str:
    lines = body.strip().split(r"\\")
    parts = []
    for line in lines:
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
    rows = body.strip().split(r"\\")
    row_strs = []
    for row in rows:
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

    # Square root: \sqrt[n]{x} → root(n, x), \sqrt{x} → sqrt(x)
    s = _replace_sqrt(s)

    # One-arg accent/decoration commands
    for latex_name, typst_name in [
        ("hat", "hat"), ("bar", "macron"), ("vec", "arrow"),
        ("dot", "dot"), ("ddot", "diaer"), ("tilde", "tilde"),
        ("overline", "overline"), ("underline", "underline"),
        ("overbrace", "overbrace"), ("underbrace", "underbrace"),
    ]:
        s = _replace_cmd_one_arg(s, latex_name, typst_name)

    # \text{...} → "..."
    s = _RE_TEXT.sub(lambda m: f'"{m.group(1)}"', s)

    # Font commands
    for latex_name, typst_name in [
        ("mathrm", "upright"), ("operatorname", "op"),
        ("mathbf", "bold"), ("boldsymbol", "bold"),
        ("mathit", "italic"), ("mathcal", "cal"),
    ]:
        s = _replace_cmd_one_arg(s, latex_name, typst_name)

    # \mathbb{X} → XX or bb(X)
    s = _RE_MATHBB.sub(
        lambda m: _MATHBB.get(m.group(1), f"bb({m.group(1)})"), s,
    )

    # Simple command replacements (precompiled, longest-first)
    for pattern, typst_rep in _COMPILED_COMMANDS:
        s = _replace_with_spacing(s, pattern, typst_rep)

    return s


# ---------------------------------------------------------------------------
# Command replacement helpers
# ---------------------------------------------------------------------------


def _replace_with_spacing(
    s: str, pattern: re.Pattern[str], typst_rep: str,
) -> str:
    """Replace a LaTeX command, adding spaces to prevent identifier merging."""
    def _padded(m: re.Match[str]) -> str:
        before = " " if m.start() > 0 and m.string[m.start() - 1].isalpha() else ""
        after = " " if m.end() < len(m.string) and m.string[m.end()].isalpha() else ""
        return before + typst_rep + after
    return pattern.sub(_padded, s)


def _replace_cmd_passthrough(s: str, latex_name: str) -> str:
    """Replace ``\\cmd{arg}`` → ``arg`` (strip the command wrapper)."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        arg, end = _extract_braced(s, m.end() - 1)
        if arg is None:
            break
        s = s[: m.start()] + arg + s[end:]
    return s


def _replace_cmd_one_arg(s: str, latex_name: str, typst_name: str) -> str:
    """Replace ``\\cmd{arg}`` → ``typst_name(arg)``."""
    pattern = re.compile(rf"\\{latex_name}\{{")
    while (m := pattern.search(s)):
        start = m.start()
        arg, end = _extract_braced(s, m.end() - 1)
        if arg is None:
            break
        prefix = " " if start > 0 and s[start - 1].isalpha() else ""
        s = s[:start] + f"{prefix}{typst_name}({arg})" + s[end:]
    return s


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
        prefix = " " if start > 0 and s[start - 1].isalpha() else ""
        s = s[:start] + f"{prefix}{typst_name}({arg1}, {arg2})" + s[after2:]
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
            s = s[: m.start()] + f"root({n_arg}, {arg})" + s[after:]
        elif pos < len(s) and s[pos] == "{":
            arg, after = _extract_braced(s, pos)
            if arg is None:
                break
            s = s[: m.start()] + f"sqrt({arg})" + s[after:]
        else:
            break
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


# ---------------------------------------------------------------------------
# Stage 4: Script conversion
# ---------------------------------------------------------------------------


def _translate_scripts(s: str) -> str:
    """Convert LaTeX brace-grouped sub/superscripts: ``_{...}`` → ``_(...)``."""
    result: list[str] = []
    i = 0
    while i < len(s):
        if i < len(s) - 1 and s[i] in ("_", "^") and s[i + 1] == "{":
            marker = s[i]
            content, end = _extract_braced(s, i + 1)
            if content is not None:
                result.append(f"{marker}({content})")
                i = end
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
        # Collect a run of letters.
        if s[i].isalpha():
            j = i
            while j < len(s) and s[j].isalpha():
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
                and not is_func_call
                and not is_dot_modifier
            ):
                result.append(f'"{word}"')
            else:
                result.append(word)
            i = j
            continue
        result.append(s[i])
        i += 1
    return "".join(result)
