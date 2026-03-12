# SVArcade — Agent Notes

This is the SVArcade project: a Godot arcade launcher showcasing student games from SVA's game design course. It runs as a kiosk on a physical arcade cabinet (NixOS) and also has a GitHub Pages web version.

---

## Current State (March 2026)

### Arcade Machine
- **NixOS 25.05** with flake at `/home/svarcade/SVArcade-2025/NIX/`
- **Godot 4.6.1** (pulled from nixpkgs-unstable overlay)
- **Auto-update on boot**: `svarcade-update.service` pulls the repo, detects NIX/ changes, rebuilds if needed
- **Kiosk session**: auto-login → X11/Openbox → Godot import + launch in restart loop
- **SSH**: via Tailscale (`svarcade@SVArcade` / `100.101.86.20`)
- **Claude Code**: installed at `~/.local/bin/claude`

### Immediate Problem
The 2024 PCK files on the machine were exported with Godot 4.3. The machine now runs Godot 4.6.1, so the old PCKs may not load. Re-exported 4.6.1 PCKs exist locally (on the dev machine) but haven't been deployed yet.

### What's Been Done
- **Web exports** (`web-exports` branch): All 2024 + 2025 games exported as HTML5, live on GitHub Pages
- **NixOS flake**: Migrated from manual `/etc/nixos/` to repo-tracked `NIX/` flake
- **PCK re-export**: All games with available sources re-exported with Godot 4.6.1 locally
- **Viewport stretch fixes**: Added `canvas_items`/`keep` to projects missing stretch settings (documented in `NIX/stretch-fixes.md`)
- **Launcher renderer**: Changed from GL Compatibility to Forward Plus (`project.godot` line 15)

### What Still Needs Doing
1. **Deploy re-exported PCKs to the machine** — the new 4.6.1-compatible PCKs need to replace the old 4.3 ones
2. **Re-export missing 2024 games** — Echo's Tale and Cheezy Escape have no source projects in the repo (need GitHub URLs); Alice's PCK (1GB) is only on the machine locally
3. **Create GameInfo .tres resources** for all 2025 games
4. **Create/capture thumbnails** for 2025 games
5. **Resolve UID main scenes** — some 2025 games use `uid://` paths in project.godot that need mapping to `res://` paths
6. **Handle oversized PCKs** — Momentum (463MB) and Trolley Problem (107MB) are too big for GitHub; use GitHub Releases or direct SCP
7. **Input mapping** — old config used gamepad; new arcade has physical buttons; needs remapping on machine

---

## Branch Guide

| Branch | Purpose |
|--------|---------|
| `main` | **Kiosk launcher** — Godot PCK-based project for the physical arcade cabinet |
| `web-exports` | **GitHub Pages site** — static HTML5 web exports |

---

## How the Kiosk Launcher Works (`main` branch)

**Project**: Godot 4.6 (upgraded from 4.3), Forward Plus, fullscreen, main scene: `res://Menus/main_menu.tscn`
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
# Classes/GameInfo.gd — one per game
extends Resource
class_name GameInfo
@export var title : String
@export var thumbnail : Texture2D
@export var authors : String
@export var pck_file : String       # e.g. "res://PCKs/memory.pck"
@export var main_scene : String     # res:// scene path inside the PCK
@export var globals : Array[String] # optional autoload scenes from the PCK
@export var clear_color : Color

# Classes/ClassProjects.gd — collection of games for a semester
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
5. **Important**: main_scene must be a `res://` path (not `uid://`) since UIDs don't resolve across PCK boundaries

---

## NixOS Flake (`NIX/`)

The arcade machine config lives in `NIX/` and is deployed via:
```
nixos-rebuild switch --flake /path/to/repo/NIX#svarcade
```

- `flake.nix` — nixos-25.05 base + Godot 4.6.1 from unstable overlay
- `configuration.nix` — kiosk config: auto-login, X11, Godot restart loop, pipewire, tailscale, SSH
- `hardware-configuration.nix` — Intel NUC-like hardware (i915, NVMe, thunderbolt)
- `kiosk-config.nix` — **archived** original manual config (reference only)

### Auto-update service
`svarcade-update.service` runs before the display manager on each boot:
1. Waits for network (60s timeout, continues without if offline)
2. `git pull --ff-only` the repo
3. Compares last commit touching `NIX/` before vs after pull
4. If changed → `nixos-rebuild switch` (falls back gracefully on failure)

### Kiosk session
After login, session commands run:
1. Set display resolution (3840x2160 HDMI)
2. Disable screen blanking, hide cursor
3. `godot4 --import` (with display, for full import)
4. `godot4 --path $REPO` in a `while true` restart loop

---

## 2024 Fall Games

| Title | PCK | Main Scene | Globals | Status |
|-------|-----|-----------|---------|--------|
| Echo's Tale | EchosTale.pck | res://scenes/levels/Opening_Menu.tscn | — | ⚠️ Old 4.3 PCK, no source in repo |
| Memory | memory.pck | res://menu/main_menu.tscn | audio_stream_player.tscn | ✅ Re-exported 4.6.1 (27M) |
| Museum Story | museum.pck | res://scenes/mian.tscn | audio_stream_player.tscn | ✅ Re-exported 4.6.1 (16M) |
| Sky Theater | sky-theater.pck | res://story1.tscn | — | ✅ Re-exported 4.6.1 (85M) |
| Alice's Tea Party | alice.pck | res://Main.tscn | Bgm.tscn | ⚠️ 1GB PCK only on machine, no source in repo |
| Cheezey Escape | cheezy.pck | res://main.tscn | — | ⚠️ Old 4.3 PCK, no source in repo |
| A Day in Prison | prison.pck | (in Prison.tres) | — | ✅ Re-exported 4.6.1 (334K) |

## 2025 Games — PCKs Exported

| Title | PCK | Size | Semester | Source Path |
|-------|-----|------|----------|-------------|
| Horror Game | horror-game.pck | 361K | Fall 2D | projects/2D-Fall25/Horror-Game/Game_Files/horror-game/ |
| Blooock | blooock.pck | 128K | Fall 2D | projects/2D-Fall25/collaborators-and-team/blooock-test/ |
| Visual Novel | visual-novel.pck | 14M | Fall 2D | projects/2D-Fall25/visualnovel/2d final/visual-novel/ |
| The Pet | the-pet.pck | 3.5M | Fall 2D | projects/2D-Fall25/Animal_Ball/the-pet/ |
| Animal Ball | animal-ball.pck | 1.1M | Fall 2D | projects/2D-Fall25/Animal_Ball/animal-ball-main/ |
| Trolley Problem | trolley-problem.pck | 107M | Fall Capstone | projects/Capstone-Fall25/TrolleyProblemGameFinalVersion/... |
| Momentum | momentum.pck | 463M | Fall Capstone | projects/Capstone-Fall25/JayLim_Final/Momentum/ |
| Group Chef | group-chef.pck | 7.6M | Spring 2D | projects/2D-Spring25/Group-Chef/新建游戏项目/ |
| Breadknight | breadknight.pck | 16M | Spring 2D | projects/2D-Spring25/James-and-Zixi-2D-game-Collab/breadknight/ |
| 2D Game Project | 2d-game.pck | 36M | Spring 2D | projects/2D-Spring25/2D-Game-Project/2d-game-project/ |
| Parsec | parsec.pck | 1.7M | Spring Capstone | projects/Capstone-Spring25/Tsegi-Capstone/tsegi-capstone-parsec/ |
| Breadknight Capstone | breadknight-capstone.pck | 16M | Spring Capstone | projects/Capstone-Spring25/James-Capstone-Game-BreadKnight/... |
| Tao Capstone | tao-capstone.pck | 3.0M | Spring Capstone | projects/Capstone-Spring25/Tao-game-/capstone-game/ |
| Mochi Adventure | mochi.pck | 7.0M | Spring Capstone | projects/Capstone-Spring25/Mochi-Final/Mochi Adventure/... |

### Main Scene UID Resolution Needed
Some 2025 games use `uid://` paths for main_scene in project.godot. These must be resolved to `res://` paths for GameInfo:
- Horror Game: `uid://ts5rkau7n6wu` → `res://Scenes/title_screen.tscn`
- Blooock: `uid://dftrqcmkrua4t` → needs resolution
- The Pet: `uid://dmau8fk0v6we0` → needs resolution
- Trolley Problem: `uid://vlbnwp2c51gk` → needs resolution
- Momentum: `uid://rotms4ajkw6i` → needs resolution
- Parsec: `uid://c72wmfajrpmal` → needs resolution
- Mochi: `uid://c1wbtif42bpc2` → needs resolution

To resolve: run `godot4 --import --path <project>`, then `grep -rl "uid://xxx" <project>/*.tscn **/*.tscn`

### Autoloads for 2025 Games
- Horror Game: Global
- Visual Novel: Game
- The Pet: Global
- Breadknight (both versions): Music
- Trolley Problem: BGM
- 2D Game Project: AudioStreamPlayer2d, UnderwaterSfx

---

## Asset Locations
- `Assets/Thumbnails/` — game thumbnail PNGs
- `Assets/ARCADE_*.TTF` — arcade-style fonts
- `Menus/` — menu music (DavidKBD Electric Pulse ogg)
- `GameResources/` — `.tres` ClassProjects + GameInfo resources
- `PCKs/` — student game PCK files
- `2024/` — 2024 game source projects
- `projects/` — 2025 game source projects (untracked)
- `NIX/` — NixOS flake for the arcade machine
