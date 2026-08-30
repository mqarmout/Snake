extends TileMapLayer

@export var level_scales: Array[int]

func get_level_center(level: int) -> Vector2:
	return get_node("level_%d" % level).position

func reset_interactables(level: int) -> void:
	for interactable in get_node("level_%d" % level).get_children():
		interactable.reset_node()

func get_reset_position(level: int) -> Vector2:
	if level == 1: return Vector2(-4, 4)
	return get_node("level_%d" % level).get_node("level_%d_exit" % level).get_reset_position()

func get_level_scale(level: int) -> int:
	return level_scales[level - 1]
