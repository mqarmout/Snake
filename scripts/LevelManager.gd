extends TileMapLayer

func get_level_center(level: int) -> Vector2:
	return get_node("level_%d" % level).position

func reset_interactables(level: int) -> void:
	for interactable in get_node("level_%d" % level).get_children():
		interactable.reset_node()

func get_reset_position(level: int) -> Vector2:
	return get_node("level_%d" % level).get_node("level_%d_exit" % level).get_reset_position()
