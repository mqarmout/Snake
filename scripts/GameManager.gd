extends Node2D

@export var snake_head: CharacterBody2D
@export var level_manager: TileMapLayer
@export var camera: Camera2D

var current_level: int = 1
var current_stage: int = 1

var reset_position: Vector2

var editor_mode: bool = false

func reset_level() -> void:
	level_manager.reset_interactables(current_level)

func level_cleared(new_reset_position: Vector2) -> void:
	current_level += 1
	reset_position = new_reset_position
	snake_head.reset_position = new_reset_position
	var current_level_center: Vector2 = level_manager.get_level_center(current_level)
	camera.move_camera(current_level_center)

func food_consumed(_object: CharacterBody2D) -> void:
	_object.interact()

func _on_ready() -> void:
	if level_manager != null:
		var current_level_center: Vector2 = level_manager.get_level_center(current_level)
		camera.move_camera(current_level_center)
	clear_multiple_levels(3)

func _process(_delta: float) -> void:
	pass

func clear_multiple_levels(amount: int) -> void:
	while amount > 0:
		level_cleared(level_manager.get_reset_position(current_level))
		amount -= 1
	snake_head.reset_head()
