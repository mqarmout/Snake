extends Area2D

@onready var game_manager: Node2D = $"../../../GameManager"
@export var reset_direction: Vector2
var size := 8

var flags := {
	"visited": false,
	"open": false,
	"perma_open": false
}

func get_reset_position() -> Vector2:
	return global_position + size * reset_direction

func interact() -> void:
	pass

func reset_node() -> void:
	modulate = Color.html("#0eb2dd")

func _on_body_entered(body: Node2D) -> void:
	if not body.name.to_lower().contains("snake"):
		return
	if not flags["open"]:
		body.reset_head()
		return
	if not flags["visited"]:
		body.level_cleared()
		game_manager.level_cleared(get_reset_position())
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		flags["visited"] = true

func _on_ready() -> void:
	if name.to_lower().contains("level_1"):
		flags["open"] = true
