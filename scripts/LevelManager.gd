extends TileMapLayer

@export var level_scales: Array[int]

func get_level_center(level: int) -> Vector2:
	return get_node("level_%d" % level).position

func reset_interactables(level: int) -> void:
	for interactable in get_node("level_%d" % level).get_children():
		interactable.reset_node()

func get_reset_position(level: int) -> Vector2:
	if level == 1: return Vector2(-4, 4)
	return get_node("level_%d" % (level - 1)).get_node("exit").get_reset_position()

func get_reset_direction(level: int) -> Vector2:
	if level == 1: return Vector2.RIGHT
	return get_node("level_%d" % (level - 1)).get_node("exit").reset_direction

func get_level_scale(level: int) -> int:
	return level_scales[level - 1]
