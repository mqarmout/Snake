extends TileMapLayer

@export var level_scales: Array[int]

func get_level_center(level: int) -> Vector2:
	return get_node("Level%d" % level).position

func reset_interactables(level: int) -> void:
	for interactable in get_node("Level%d" % level).get_children():
		interactable.reset_node()

func get_reset_position(level: int) -> Vector2:
	if level == 1: return Vector2(-4, 4)
	return get_node("Level%d" % (level - 1)).get_node("Exit").get_reset_position()

func get_reset_direction(level: int) -> Vector2:
	if level == 1: return Vector2.RIGHT
	return get_node("Level%d" % (level - 1)).get_node("Exit").reset_direction

func get_level_scale(level: int) -> int:
	print(level_scales)
	return level_scales[level - 1]

func has_next_level(level: int) -> bool:
	return get_node_or_null("Level%d" % (level)) != null
