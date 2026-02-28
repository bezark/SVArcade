# SVArcade — Agent Notes

This is the SVArcade project: a Godot 4.3 arcade launcher showcasing student games from SVA's game design course. It runs as a kiosk on a physical arcade cabinet (NixOS) and also has a GitHub Pages web version.

---

## Branch Guide

| Branch | Purpose |
|--------|---------|
| `main` | **Kiosk launcher** — full Godot PCK-based project for the physical arcade cabinet |
| `web-exports` | **GitHub Pages site** — static HTML5 web exports, no Godot launcher needed |
| `Game-Edits` | Development branch for menu UI work (largely merged into main) |
| `nix-arcade` | NixOS config for building the bootable arcade cabinet ISO |
| `pck-Testing` | Early PCK loading experiments (obsolete) |
| `MarchArchive` | Archive snapshot from March 2025 |

---

## How the Kiosk Launcher Works (`main` branch)

**Project**: Godot 4.3, GL Compatibility, fullscreen, main scene: `res://Menus/main_menu.tscn`
**Autoload**: `Metagame` → `res://Utils/metagame.tscn`

### PCK Loading Flow
1. `Menus/GridLoader.tscn` reads a `ClassProjects` resource (exported field)
2. Spawns one `GameButton` (TextureButton) per game in a grid
3. User selects → `context.tscn` (CanvasLayer) shows title/authors/Play button
4. Play → `PCKImporter.load_pck(pck_file, main_scene, globals, clear_color)`
5. `Metagame.load_game()` calls `get_tree().change_scene_to_packed(scene)`
6. "quit" input action → returns to `res://Menus/main_menu.tscn`

### Key Scripts
- `Utils/metagame.gd` — Singleton: load_game(), quit handler, idle timeout, music control
- `Utils/pck_importer.gd` — Calls ProjectSettings.load_resource_pack(), then Metagame.load_game()
- `Menus/grid_loader.gd` — Reads ClassProjects, spawns GameButton nodes
- `Menus/game_button.gd` — TextureButton showing thumbnail+title, opens context card on press
- `Menus/context.gd` — Shows game info, triggers PCK load on Play
- `Menus/idle.gd` — Attract/idle screen, returns to menu on joypad input

### Data Classes
```gdscript
# Classes/GameInfo.gd
extends Resource
class_name GameInfo
@export var title : String
@export var thumbnail : Texture2D
@export var authors : String
@export var pck_file : String       # e.g. "res://PCKs/memory.pck"
@export var main_scene : String     # scene path inside the PCK
@export var globals : Array[String] # optional autoload scenes from the PCK
@export var clear_color : Color

# Classes/ClassProjects.gd
extends Resource
class_name ClassProjects
@export var date : String
@export var projects : Array[GameInfo]
```

### Adding a New Game (main branch)
1. Export student's Godot project as `.pck` → place in `PCKs/`
2. Add a thumbnail PNG → `Assets/Thumbnails/`
3. Create a `GameInfo` entry in the appropriate `GameResources/YEAR-SEMESTER.tres`
4. Make sure `globals` includes any autoload scenes the game needs

---

## How the Web Version Works (`web-exports` branch)

No Godot launcher. Each game is exported as HTML5 and placed in `exports/GameName/`:
```
exports/GameName/
  index.html
  index.js
  index.pck
  index.wasm
  index.png
  index.icon.png
  index.apple-touch-icon.png
  index.audio.worklet.js
```
`README.md` in root lists links to each game folder (served via GitHub Pages).

### Adding a New Game (web-exports branch)
1. Export student's Godot project as Web (HTML5)
2. Create folder `exports/GameName/`, copy all export files in
3. Add link to `README.md`

---

## 2024 Fall Games (Already Complete)

| Title | Authors | PCK | Main Scene | Notes |
|-------|---------|-----|-----------|-------|
| Echoe's Tale | (see EchosTale.tres) | EchosTale.pck | in .tres | Separate resource file |
| Memory | Dazhong Deng & Ruoxin Yu | memory.pck | res://menu/main_menu.tscn/ | globals: audio_stream_player.tscn |
| Museum Story | Chuhan Ji & Bryan Pang | museum.pck | res://scenes/mian.tscn | globals: audio_stream_player.tscn |
| Sky Theater | Mordred Huang | sky-theater.pck | res://story1.tscn | |
| Alice's Amazing Tea Party | Norika Katsuya & Christine Yang | alice.pck | res://Main.tscn | globals: Bgm.tscn |
| The Cheezey Escape | Mordred Huang, Zhenyi Wang & Yisheng Zhang | cheezy.pck | res://main.tscn | |
| A Day in Prison | (see Prison.tres) | Prison.pck | in .tres | |
| Get Down Stay Cool | — | — | — | Web export only |

---

## 2025 Games — TODO

Zips available in `2025zips/` (untracked):
- `2D-Fall25.zip`
- `2D-Spring25.zip`
- `Capstone-Fall25.zip`
- `Capstone-Spring25.zip`

**Next steps**:
1. Unzip and review student projects
2. For `web-exports` branch: export each as HTML5, add to `exports/`, update README
3. For `main` branch: export each as `.pck`, add GameInfo resources, add thumbnails
4. Update README with 2025 section

---

## Asset Locations
- `Assets/Thumbnails/` — game thumbnail PNGs
- `Assets/ARCADE_*.TTF` — arcade-style fonts
- `Menus/` — menu music (DavidKBD Electric Pulse ogg)
- `GameResources/` — `.tres` ClassProjects + GameInfo resources
- `PCKs/` — student game PCK files (main branch only)
- `exports/` — HTML5 web exports (web-exports branch only)

## Source Projects (2024)
- `2024/alice-in-a-mazing-tea-party/` — Alice source (complex 3D project)
- `2024/sky-theater - 副本/` — Sky Theater source
- `2024/2DGames/` — 2D game sources (Prison, Memory, Museum, Music)
