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

**Levels (`scripts/LevelManager.gd`, `scenes/level_manager.tscn`).** All 5 levels' tiles are
hand-painted directly into the one `LevelManager` `TileMapLayer` in the editor — there is no
runtime stage parsing or procedural generation. `stages/stage_N.txt` is a leftover from an earlier
text-format-driven approach and is no longer read by anything. Under `LevelManager`, `level_1`
through `level_5` are `Node2D` containers, each with its own `position` marking that level's
camera-anchor point and holding that level's `Food`/`Exit` instances as children (positioned
locally to the container). `LevelManager.get_level_center(level)` returns
`get_node("level_%d" % level).position`; `GameManager.level_cleared()`/`_on_ready()` call it to
pan the camera. `Food.gd` and `Exit.gd` both implement `interact()` (called from
`GameManager.food_consumed()`) and `reset_node()` (called by
`LevelManager.reset_interactables(level)`, which just loops `get_node("level_%d" %
level).get_children()` — see `GameManager.reset_level()`), so a new interactable type only needs to
implement that pair, not be special-cased in `GameManager`/`LevelManager`. Adding a 6th level means
adding a `level_6` `Node2D` under `LevelManager` with its own `position` — no array to keep in
sync elsewhere.

**Camera.** `scripts/camera.gd` is a thin wrapper (`move_camera(pos)`) — the camera snaps to a
level's center on `level_cleared()`, it doesn't follow the snake continuously.
