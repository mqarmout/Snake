extends Area2D

@export var connected_exit: Area2D

var pressure_count := 0

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("snake"):
		pressure_count += 1

func _on_body_exited(body: Node2D) -> void:
	if body.name.to_lower().contains("snake"):
		pressure_count -= 1

func update_entity() -> void:
	pass

func reset_node() -> void:
	pass

func interact() -> void:
	pass

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	connected_exit.flags["open"] = pressure_count > 0
