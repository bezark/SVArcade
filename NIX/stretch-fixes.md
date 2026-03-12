# Viewport Stretch Fixes (2026-03-12)

Added `window/stretch/mode="canvas_items"` and `window/stretch/aspect="keep"` to projects
that were missing stretch settings. This prevents the camera from looking bad when the
window expands to fullscreen on the arcade cabinet (3840x2160).

If a game looks wrong (zoomed in, cropped, or distorted), revert its stretch settings
by removing the lines added below, or try `mode="viewport"` instead of `"canvas_items"`.

## Projects modified

### 2024
- `2024/sky-theater - 副本/project.godot` — added `aspect="keep"` (already had mode)
- `2024/alice-in-a-mazing-tea-party/project.godot` — added full [display] section
- `2024/2DGames/DATA-VIZ_PrisonSystem/Prison Life Visualization/prisonlife/project.godot` — added `aspect="keep"`

### 2025 Fall
- `projects/2D-Fall25/Animal_Ball/animal-ball-main/project.godot` — added full [display] section
- `projects/2D-Fall25/collaborators-and-team/blooock-test/project.godot` — added full [display] section
- `projects/2D-Fall25/visualnovel/2d final/visual-novel/project.godot` — added stretch to existing [display]
- `projects/Capstone-Fall25/JayLim_Final/Momentum/project.godot` — added stretch to existing [display]

### 2025 Spring
- `projects/2D-Spring25/Group-Chef/新建游戏项目/project.godot` — added full [display] section

## Projects already correct (not modified)
- Memory (2024) — `viewport`
- Museum (2024) — `canvas_items`
- Horror Game (2025 Fall) — `viewport` + `expand`
- The Pet (2025 Fall) — `canvas_items`
- Breadknight (2025 Spring) — `canvas_items`
- Trolley Problem (2025 Fall Capstone) — `canvas_items`
- Parsec (2025 Spring Capstone) — `viewport`
- Tao Capstone (2025 Spring) — `viewport`
- Mochi Adventure (2025 Spring Capstone) — `canvas_items` + `expand`
