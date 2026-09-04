extends CharacterBody2D

func update_entity() -> void:
	pass

func interact() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func reset_node() -> void:
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func _on_ready() -> void:
	pass
