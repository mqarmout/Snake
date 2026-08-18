# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A grid-based Snake game built in Godot 4.7 (GL Compatibility renderer). Unrelated to the other
NYOMNYOM_* repos in this workspace — standalone project. No README, no test suite; this is a
solo game-dev project driven from the Godot editor.

## Commands

There's no CLI build/test workflow — this is developed and run from the Godot editor (open
`project.godot` in Godot 4.7). Run the project with the editor's Play button / F5, which launches
`res://scenes/Main.tscn` (set as `run/main_scene` in `project.godot`). Version control is done
through the built-in `godot-git-plugin` addon (`addons/godot-git-plugin/`) rather than a separate
git GUI.

## Architecture

**Scene tree (`scenes/Main.tscn`).** Four top-level siblings: `LevelManager` (a `TileMapLayer`),
`SnakeHead`, `Camera`, and `GameManager`, which holds exported references to the other three and
coordinates them — it's the only node that calls across the others (`SnakeHead` and
`LevelManager` don't reference each other directly except `SnakeHead` calling
`game_manager.food_consumed()` / `game_manager.reset_level()` / `game_manager.level_cleared()`).

**Grid movement (`scripts/SnakeHead.gd`, `scripts/SnakeBody.gd`).** Movement is tile-stepped, not
continuous: `cell_size = 8` px per step. `SnakeHead.move()` only starts a new step once the
previous one lands exactly on `target` (`target == position`), reading input via
`Input.get_vector("left","right","up","down")`. Body segments follow via a directional queue:
`body_directions` records the direction the segment ahead of each body part moved on the last
step (`update_queue()` shifts the array each step), and `update_children()` applies
`body_directions[i]` to `body_parts[i]`'s target — i.e. each segment follows the path the one
ahead of it took one step ago, not the head's live position. When adding new snake behavior
(growth, speed changes), this queue is the piece to extend, not per-segment position tracking.

**Levels and stages (`scripts/LevelManager.gd`, `stages/stage_N.txt`).** A "stage" is a custom
text format (parsed in `load_stage()`), split on `"s"` into stages, each stage further split into
4-line records per level: start coordinate, dimensions, object type list, object location list.
`load_stage()` builds a bordered grid per level (`1` = wall, `0` = floor) and stamps object codes
(from `object_types`, e.g. `3` = Exit, `4` = Food) into their cells. `tile_types` maps a cell code
to a tileset atlas coordinate for `set_cell()`. Only one level is drawn/active at a time
(`draw_level`); `GameManager.level_cleared()` advances `current_level` and re-centers the camera
via `get_current_level_center()`. `draw_all_levels()` and the in-progress `update_stage_text_file()`
(meant to save editor changes back to the stage file) are present but not wired into normal play —
treat them as unfinished/experimental if touching level authoring.

**Camera.** `scripts/camera.gd` is a thin wrapper (`move_camera(pos)`) — the camera snaps to a
level's center on `level_cleared()`, it doesn't follow the snake continuously.
