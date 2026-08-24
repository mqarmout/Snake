extends CharacterBody2D

func consume() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func reset_food() -> void:
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func _on_ready() -> void:
	self.name = "Food"
