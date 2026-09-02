extends Node2D

var snake_head: CharacterBody2D
var level_manager: TileMapLayer
var camera: Camera2D

const SAVEPATH := "user://savegame.cfg"

const END_SCREEN := "res://scenes/end_screen.tscn"
const START_MENU := "res://scenes/start_menu.tscn"
const STAGE_1 := "res://scenes/stage_1.tscn"

const SNAKE_BODY = preload("res://scenes/snake_body.tscn")

var current_level := 11
var current_stage := 1

var reset_position: Vector2
var reset_direction: Vector2

func _on_ready() -> void:
	#load_game()
	if level_manager == null or snake_head == null or camera == null:
		print("snake head: %s\nlevel manager: %s\ncamera: %s" % [snake_head, level_manager, camera])
		return
	
	var current_level_center: Vector2 = level_manager.get_level_center(current_level)
	camera.move_camera(current_level_center)
	camera.zoom_camera(level_manager.get_level_scale(current_level))
	reset_position = level_manager.get_reset_position(current_level)
	reset_direction = level_manager.get_reset_direction(current_level)
	snake_head.reset_position = reset_position
	snake_head.reset_direction = reset_direction
	snake_head.snake_body_scene = SNAKE_BODY
	snake_head.reset_head()

func _process(_delta: float) -> void:
	pass

func register_scenes(_snake_head: CharacterBody2D, _level_manager: TileMapLayer, _camera: Camera2D) -> void:
	snake_head = _snake_head
	level_manager = _level_manager
	camera = _camera

func get_reset_position() -> Vector2:
	return level_manager.get_reset_position(current_level)

func get_reset_direction() -> Vector2:
	return level_manager.get_reset_direction(current_level)

func reset_level() -> void:
	level_manager.reset_interactables(current_level)

func level_cleared(_reset_position: Vector2, _reset_direction: Vector2) -> void:
	if not level_manager.has_next_level(current_level + 1):
		get_tree().change_scene_to_file.call_deferred(END_SCREEN)
		return
	current_level += 1
	reset_position = _reset_position
	reset_direction = _reset_direction
	var current_level_center: Vector2 = level_manager.get_level_center(current_level)
	camera.move_camera(current_level_center)
	camera.zoom_camera(level_manager.get_level_scale(current_level))
	snake_head.level_cleared(_reset_position, _reset_direction)
	#save_game()

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

func start_game() -> void:
	get_tree().change_scene_to_file.call_deferred(STAGE_1)
