extends Area2D

@export var reset_direction: Vector2
const SIZE := 8

var flags := {
	"visited": false,
	"open": false,
	"perma_open": false
}

func get_reset_position() -> Vector2:
	return global_position + SIZE * reset_direction

func interact() -> void:
	pass

func reset_node() -> void:
	modulate = Color.html("#0eb2dd")

func _on_body_entered(body: Node2D) -> void:
	if not body.name.to_lower().contains("snake"):
		return
	if not flags["open"]:
		body.reset_head()
		GameManager.reset_level()
		return
	if not flags["visited"]:
		GameManager.level_cleared(get_reset_position(), reset_direction)
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		flags["visited"] = true

func _on_ready() -> void:
	if get_parent().name.to_lower().contains("level1"):
		flags["open"] = true
