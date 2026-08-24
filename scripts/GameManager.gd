extends Node2D

@export var snake_head: CharacterBody2D
#@export var level_manager: TileMapLayer
@export var camera: Camera2D

var current_level: int = 1
var current_stage: int = 1

var reset_position: Vector2

var editor_mode: bool = false

var consumed_food: Array[CharacterBody2D] = []

func reset_level() -> void:
	for food in consumed_food:
		food.reset_food()
	consumed_food.clear()
	print("resetting level")

func level_cleared(new_reset_position: Vector2) -> void:
	#level_manager.clear_level(current_level)
	current_level += 1
	reset_position = new_reset_position
	snake_head.reset_position = new_reset_position
	#var current_level_center: Vector2 = level_manager.get_current_level_center(current_stage, current_level)
	#camera.move_camera(current_level_center)

func food_consumed(_object: CharacterBody2D) -> void:
	_object.consume()
	consumed_food.append(_object)

func _on_ready() -> void:
	#level_manager.load_stage(current_stage)
	#level_manager.draw_all_levels(current_stage)
	#level_manager.draw_level(current_stage, current_level)
	#var current_level_center: Vector2 = level_manager.get_current_level_center(current_stage, current_level)
	#camera.move_camera(current_level_center)
	#clear_multiple_levels(3)
	pass

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("editor_toggle"):
		#editor_mode = !editor_mode
		#if !editor_mode:
			#level_manager.update_stage_text_file()
	pass

func clear_multiple_levels(amount: int) -> void:
	while amount > 0:
		level_cleared(reset_position)
		amount -= 1
