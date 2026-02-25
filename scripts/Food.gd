extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "SnakeHead":
		body.food_consumed()
		queue_free()
