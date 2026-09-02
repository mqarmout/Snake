extends Node2D

@export var snake_head: CharacterBody2D
@export var level_manager: TileMapLayer
@export var camera: Camera2D

func _ready() -> void:
	GameManager.register_scenes(snake_head, level_manager, camera)
	GameManager._on_ready()
