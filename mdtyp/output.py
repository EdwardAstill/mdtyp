"""Protect source files and publish conversion outputs only after success."""

import subprocess
import tempfile
from pathlib import Path


def write_output(
    text: str, dest: Path, *, sources: tuple[Path, ...] = (), pdf: bool = False,
) -> None:
    """Reject path collisions, then stage outputs before replacing existing files."""
    outputs = (dest, dest.with_suffix(".pdf")) if pdf else (dest,)
    for index, target in enumerate(outputs):
        if target.is_dir():
            raise IsADirectoryError(f"Output {target} is a directory")
        for protected in (*sources, *outputs[:index]):
            if target.resolve() == protected.resolve() or (
                target.exists() and protected.exists() and target.samefile(protected)
            ):
                raise ValueError(f"Output {target} would overwrite {protected}")
    with tempfile.NamedTemporaryFile(
        mode="w", encoding="utf-8", suffix=".typ", prefix=".mdtyp-",
        dir=dest.parent, delete=False,
    ) as staged:
        staged_path = Path(staged.name)
        try:
            staged.write(text)
            staged.close()
            if pdf:
                with tempfile.TemporaryDirectory(prefix=".mdtyp-", dir=dest.parent) as temp_dir:
                    staged_pdf = Path(temp_dir) / "output.pdf"
                    subprocess.run(
                        ["typst", "compile", str(staged_path), str(staged_pdf)],
                        capture_output=True, text=True, check=True,
                    )
                    staged_path.replace(dest)
                    staged_pdf.replace(dest.with_suffix(".pdf"))
            else:
                staged_path.replace(dest)
        finally:
            staged_path.unlink(missing_ok=True)
