"""Protect source files when writing conversion outputs."""

from pathlib import Path


def write_output(
    text: str, dest: Path, *, sources: tuple[Path, ...] = (), pdf: bool = False,
) -> None:
    """Reject output aliases of inputs or each other before writing anything."""
    outputs = (dest, dest.with_suffix(".pdf")) if pdf else (dest,)
    for index, target in enumerate(outputs):
        for protected in (*sources, *outputs[:index]):
            if target.resolve() == protected.resolve() or (
                target.exists() and protected.exists() and target.samefile(protected)
            ):
                raise ValueError(f"Output {target} would overwrite {protected}")
    dest.write_text(text, encoding="utf-8")
