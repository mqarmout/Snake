extends Node2D

@export var snake_head: CharacterBody2D
@export var level_manager: TileMapLayer
@export var camera: Camera2D

const SAVEPATH := "user://savegame.cfg"

var current_level := 1
var current_stage := 1

var reset_position: Vector2

func _on_ready() -> void:
	load_game()
	if level_manager != null:
		var current_level_center: Vector2 = level_manager.get_level_center(current_level)
		camera.move_camera(current_level_center)
		camera.zoom_camera(level_manager.get_level_scale(current_level))
		reset_position = level_manager.get_reset_position(current_level)
		snake_head.reset_position = reset_position
		snake_head.reset_head()

func _process(_delta: float) -> void:
	pass

func reset_level() -> void:
	level_manager.reset_interactables(current_level)

func level_cleared(new_reset_position: Vector2) -> void:
	current_level += 1
	reset_position = new_reset_position
	snake_head.reset_position = new_reset_position
	var current_level_center: Vector2 = level_manager.get_level_center(current_level)
	camera.move_camera(current_level_center)
	camera.zoom_camera(level_manager.get_level_scale(current_level))
	save_game()

func food_consumed(_object: CharacterBody2D) -> void:
	_object.interact()

func save_game() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "current_stage", current_stage)
	config.set_value("progress", "current_level", current_level)
	config.save(SAVEPATH)

func load_game() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVEPATH)
	if err == OK:
		current_stage = config.get_value("progress", "current_stage", current_stage)
		current_level = config.get_value("progress", "current_level", current_level)
