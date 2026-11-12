"""TUI file browser for mdtyp."""

import os
import shlex
import subprocess
from pathlib import Path

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.reactive import reactive
from textual.widgets import Footer, Header, Label, ListItem, ListView

from mdtyp.config import Config, load_config
from mdtyp.output import write_output

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

    current_dir: reactive[Path] = reactive(Path("."), init=False)

    def __init__(self, config: Config | None = None) -> None:
        super().__init__()
        self._paths: dict[str, Path] = {}
        self.config = config if config is not None else load_config()

    def compose(self) -> ComposeResult:
        yield Header()
        yield ListView(id="file-list")
        yield Footer()

    def on_mount(self) -> None:
        self.current_dir = Path.cwd()

    async def watch_current_dir(self, new_dir: Path) -> None:
        self.sub_title = str(new_dir)
        lv = self.query_one("#file-list", ListView)
        await lv.clear()
        self._paths = {}

        try:
            raw = list(new_dir.iterdir())
        except OSError as error:
            self.notify(str(error), severity="error")
            return

        entries = sorted(
            (e for e in raw if not e.name.startswith(".")),
            key=lambda p: (not p.is_dir(), p.name.lower()),
        )

        items = []
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
            items.append(item)
        await lv.extend(items)
        lv.index = 0 if items else None

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
        try:
            editor = shlex.split(os.environ.get("EDITOR") or "vi")
            with self.suspend():
                subprocess.run([*editor, str(path)])
        except (OSError, ValueError) as error:
            self.notify(f"Cannot open editor: {error}", severity="error")

    def action_convert_typst(self) -> None:
        path = self._selected_path()
        if path is None or path.suffix != ".md":
            return
        from mdtyp.converter import convert
        dest = path.with_suffix(".typ")
        try:
            typst_text = convert(path.read_text(encoding="utf-8"), self.config)
            write_output(typst_text, dest, sources=(path,))
        except (ValueError, OSError) as error:
            self.notify(str(error), severity="error")
            return
        self.notify(f"Written: {dest.name}")

    def action_convert_pdf(self) -> None:
        path = self._selected_path()
        if path is None or path.suffix != ".md":
            return
        from mdtyp.converter import convert
        typ_path = path.with_suffix(".typ")
        try:
            typst_text = convert(path.read_text(encoding="utf-8"), self.config)
            write_output(typst_text, typ_path, sources=(path,), pdf=True)
        except subprocess.CalledProcessError as error:
            self.notify(f"typst failed: {error.stderr.strip()[:80]}", severity="error")
            return
        except (ValueError, OSError) as error:
            self.notify(str(error), severity="error")
            return
        self.notify(f"PDF: {typ_path.with_suffix('.pdf').name}")
