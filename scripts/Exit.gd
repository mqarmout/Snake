extends Area2D

@onready var game_manager: Node2D = $"../GameManager"

#func _on_body_entered(body: Node2D) -> void:
	#if body.name == "SnakeHead":
		#game_manager.cleared_level()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "SnakeHead":
		game_manager.level_cleared()


func _on_ready() -> void:
	self.name = "Exit"
