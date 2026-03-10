extends Node2D

@onready var snake_head: CharacterBody2D = $"../SnakeHead"
@onready var level_manager: TileMapLayer = $"../LevelManager"

var current_level:int = 1
var current_stage:int = 1

func win() -> void:
	snake_head.reset_location(Vector2.ZERO, Vector2.RIGHT)

func load_next_level() -> void:
	current_level += 1
	level_manager.draw_level(current_stage, current_level)

func food_consumed(_object: Area2D):
	level_manager.free_object(_object)
