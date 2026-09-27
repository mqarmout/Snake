extends TileMapLayer

@export var level_scales: Array[int]

func update_entities(level: int) -> void:
	for interactable in get_node("Level%d" % level).get_node("Interactables").get_children():
		interactable.update_entity()

func reset_entities(level: int) -> void:
	for interactable in get_node("Level%d" % level).get_node("Interactables").get_children():
		interactable.reset_node()

func get_reset_position(level: int) -> Vector2:
	if level == 1: return Vector2(-4, 4)
	return get_node("Level%d" % (level - 1)).get_node("Interactables").get_node("Exit").get_reset_position()

func get_reset_direction(level: int) -> Vector2:
	if level == 1: return Vector2.RIGHT
	return get_node("Level%d" % (level - 1)).get_node("Interactables").get_node("Exit").get_reset_direction()

func get_level_scale(level: int) -> int:
	return level_scales[level - 1]

func get_level_center(level: int) -> Vector2:
	return get_node("Level%d" % level).position

func has_level(level: int) -> bool:
	return get_node_or_null("Level%d" % (level)) != null

func hide_level(level: int) -> void:
	get_node("Level%d" % level).get_node("Visuals").get_node("Cover").visible = true

func show_level(level: int) -> void:
	get_node("Level%d" % level).get_node("Visuals").get_node("Cover").visible = false

func hide_all_levels() -> void:
	for child in get_children():
		child.get_node("Visuals").get_node("Cover").visible = true
