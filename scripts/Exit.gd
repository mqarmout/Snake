extends Area2D

@onready var game_manager: Node2D = $"../GameManager"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "SnakeHead":
		#move camera to center next level center
		pass
		#game_manager.win()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "SnakeHead":
		pass
		#game_manager.load_next_level()
