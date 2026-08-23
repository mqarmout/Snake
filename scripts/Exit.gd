extends Area2D

@onready var game_manager: Node2D = $"../../GameManager"
@export var reset_position: Vector2

#func _on_body_entered(body: Node2D) -> void:
	#if body.name == "SnakeHead":
		#game_manager.level_cleared(reset_position)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "SnakeHead":
		game_manager.level_cleared(reset_position)

func _on_ready() -> void:
	#self.name = "Exit"
	pass
