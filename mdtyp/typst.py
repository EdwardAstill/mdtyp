"""Serialize literal strings for Typst code."""

import json
import re


def typst_string(text: str) -> str:
    """Encode a string, including controls whose JSON escapes differ in Typst."""
    def control(match: re.Match[str]) -> str:
        escape = match[1]
        if escape == "\\":
            return match[0]
        code = escape[1:] if escape.startswith("u") else {"b": "8", "f": "c"}[escape]
        return f"\\u{{{code}}}"

    return re.sub(r"\\(\\|u[0-9a-f]{4}|[bf])", control, json.dumps(text, ensure_ascii=False))
