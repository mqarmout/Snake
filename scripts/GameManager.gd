extends Node2D

@export var snake_head: CharacterBody2D
@export var level_manager: TileMapLayer
@export var camera: Camera2D

var current_level: int = 1
var current_stage: int = 1

var editor_mode: bool = false

func reset_level() -> void:
	level_manager.clear_level(current_level)
	level_manager.place_interactables(current_level)

func level_cleared() -> void:
	level_manager.clear_level(current_level)
	current_level += 1
	var current_level_center: Vector2 = level_manager.get_current_level_center(current_stage, current_level)
	camera.move_camera(current_level_center)

func food_consumed(_object: Area2D):
	level_manager.free_object(_object, current_level)

func _on_ready() -> void:
	level_manager.draw_all_levels(current_stage)
	var current_level_center: Vector2 = level_manager.get_current_level_center(current_stage, current_level)
	camera.move_camera(current_level_center)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("editor_toggle"):
		editor_mode = !editor_mode
		print("editor")
