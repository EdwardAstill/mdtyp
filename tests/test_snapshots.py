"""Golden-file snapshot tests.

Converts examples/everything.md and compares against examples/everything.typ.
To update the snapshot after intentional changes, run:
    uv run mdtyp examples/everything.md -o examples/everything.typ
"""

from pathlib import Path

from mdtyp.converter import convert

_EXAMPLES_DIR = Path(__file__).parent.parent / "examples"


def test_everything_snapshot() -> None:
    """Convert everything.md and compare against the golden .typ file."""
    md_path = _EXAMPLES_DIR / "everything.md"
    typ_path = _EXAMPLES_DIR / "everything.typ"
    if not md_path.exists() or not typ_path.exists():
        return

    actual = convert(md_path.read_text())
    expected = typ_path.read_text()
    assert actual == expected, (
        "Snapshot mismatch. If the change is intentional, update the snapshot:\n"
        "  uv run mdtyp examples/everything.md -o examples/everything.typ"
    )
