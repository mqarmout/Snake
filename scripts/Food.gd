extends Area2D
#
#@onready var game_manager: Node2D = $"../GameManager"
#
#func _on_body_entered(body: Node2D) -> void:
	#if body.name == "SnakeHead":
		#body.food_consumed()
		#game_manager.food_consumed(self)


func _on_ready() -> void:
	self.name = "Food"
