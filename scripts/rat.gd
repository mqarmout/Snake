extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("snake"):
		body.reset_head()

func interact() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func reset_node() -> void:
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
