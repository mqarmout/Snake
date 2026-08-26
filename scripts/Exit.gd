extends Area2D

@onready var game_manager: Node2D = $"../../../GameManager"
@export var reset_position: Vector2

func _on_body_exited(body: Node2D) -> void:
	if body.name == "SnakeHead":
		game_manager.level_cleared(reset_position)

func interact() -> void:
	pass

func reset_node() -> void:
	print("reset exit")
	pass

func _on_ready() -> void:
	pass
