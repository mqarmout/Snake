extends Area2D

@onready var game_manager: Node2D = $"../../../GameManager"
@export var reset_position: Vector2

var flags := {
	"visited": false
}

func interact() -> void:
	pass

func reset_node() -> void:
	modulate = Color.html("#0eb2dd")

func _on_body_entered(body: Node2D) -> void:
	if not flags["visited"]:
		body.level_cleared()
		game_manager.level_cleared(reset_position)
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		flags["visited"] = true

func _on_ready() -> void:
	pass
