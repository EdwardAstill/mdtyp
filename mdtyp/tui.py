"""TUI file browser for mdtyp."""

import os
import subprocess
from pathlib import Path

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.reactive import reactive
from textual.widgets import Footer, Header, Label, ListItem, ListView


class MdtypBrowser(App[None]):
    """Interactive Markdown file browser."""

    TITLE = "mdtyp"
    CSS = """
    #file-list {
        height: 1fr;
        border: none;
    }
    .dir-item > Label {
        color: $accent;
        text-style: bold;
    }
    .md-item > Label {
        color: $success;
    }
    .other-item > Label {
        color: $text-muted;
        opacity: 0.6;
    }
    """
    BINDINGS = [
        Binding("q", "quit", "Quit"),
        Binding("o", "open_editor", "Editor"),
        Binding("t", "convert_typst", "→ Typst"),
        Binding("p", "convert_pdf", "→ PDF"),
        Binding("backspace", "go_up", "Go up", show=False),
        Binding("left", "go_up", "Go up", show=False),
        Binding("h", "go_up", "Go up", show=False),
    ]

    current_dir: reactive[Path] = reactive(Path("."))

    def __init__(self) -> None:
        super().__init__()
        self._paths: dict[str, Path] = {}

    def compose(self) -> ComposeResult:
        yield Header()
        yield ListView(id="file-list")
        yield Footer()

    def on_mount(self) -> None:
        self.current_dir = Path.cwd()

    def watch_current_dir(self, new_dir: Path) -> None:
        self.sub_title = str(new_dir)
        self._load_directory()

    def _load_directory(self) -> None:
        lv = self.query_one("#file-list", ListView)
        lv.clear()
        self._paths = {}

        try:
            raw = list(self.current_dir.iterdir())
        except PermissionError:
            self.notify("Permission denied", severity="error")
            return

        entries = sorted(
            (e for e in raw if not e.name.startswith(".")),
            key=lambda p: (not p.is_dir(), p.name.lower()),
        )

        for i, entry in enumerate(entries):
            key = f"entry-{i}"
            self._paths[key] = entry
            if entry.is_dir():
                item = ListItem(Label(f"\u25b6 {entry.name}/"), id=key)
                item.add_class("dir-item")
            elif entry.suffix == ".md":
                item = ListItem(Label(f"  {entry.name}"), id=key)
                item.add_class("md-item")
            else:
                item = ListItem(Label(f"  {entry.name}"), id=key)
                item.add_class("other-item")
            lv.append(item)

    def _selected_path(self) -> Path | None:
        lv = self.query_one("#file-list", ListView)
        child = lv.highlighted_child
        if child is None or child.id is None:
            return None
        return self._paths.get(child.id)

    def check_action(self, action: str, parameters: object) -> bool | None:
        if action in ("open_editor", "convert_typst", "convert_pdf"):
            path = self._selected_path()
            return path is not None and path.suffix == ".md"
        return True

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        if event.item.id is None:
            return
        path = self._paths.get(event.item.id)
        if path is not None and path.is_dir():
            self.current_dir = path

    def action_go_up(self) -> None:
        parent = self.current_dir.parent
        if parent != self.current_dir:
            self.current_dir = parent

    def action_open_editor(self) -> None:
        path = self._selected_path()
        if path is None or path.suffix != ".md":
            return
        editor = os.environ.get("EDITOR", "vi")
        with self.suspend():
            subprocess.run([editor, str(path)])

    def action_convert_typst(self) -> None:
        path = self._selected_path()
        if path is None or path.suffix != ".md":
            return
        from mdtyp.config import load_config
        from mdtyp.converter import convert
        config = load_config(None)
        typst_text = convert(path.read_text(encoding="utf-8"), config)
        dest = path.with_suffix(".typ")
        dest.write_text(typst_text)
        self.notify(f"Written: {dest.name}")

    def action_convert_pdf(self) -> None:
        path = self._selected_path()
        if path is None or path.suffix != ".md":
            return
        from mdtyp.config import load_config
        from mdtyp.converter import convert
        config = load_config(None)
        typst_text = convert(path.read_text(encoding="utf-8"), config)
        typ_path = path.with_suffix(".typ")
        typ_path.write_text(typst_text)
        try:
            result = subprocess.run(
                ["typst", "compile", str(typ_path)],
                capture_output=True,
                text=True,
            )
        except FileNotFoundError:
            self.notify("'typst' not found — install Typst for PDF", severity="error")
            return
        if result.returncode != 0:
            self.notify(
                f"typst failed: {result.stderr.strip()[:80]}",
                severity="error",
            )
        else:
            self.notify(f"PDF: {typ_path.with_suffix('.pdf').name}")
