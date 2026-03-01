extends TileMapLayer

@onready var Food_Scene = preload("res://scenes/Food.tscn")
@onready var exit_scene = preload("res://scenes/Exit.tscn")
var object_displacement:Vector2 = Vector2(4,4)
var object_displacement_multiplier:int = 8
var placed_objects = []

var stages = []
var tile_types = {
	0: Vector2(1,0),
	1: Vector2(4,0),
	2: Vector2(7,4),
	3: Vector2(1,0),
	4: Vector2(1,0),
	5: Vector2(6,0),
	6: Vector2(5,8),
	7: Vector2(5,8),
	8: Vector2(2,9)
}

var object_types = {}

func _on_ready() -> void:
	setup_objects_dictionary()
	load_levels_file_content()
	draw_level(1, 1)

func setup_objects_dictionary() -> void:
	object_types = {
		3: exit_scene,
		4: Food_Scene
	}

func free_object(_object:Area2D):
	var index:int = 0
	for placed_object in placed_objects:
		if placed_object == _object:
			placed_objects.pop_at(index)
			_object.queue_free()
			return
		index += 1

func add_object(attachement_position:Vector2, object_scene:PackedScene) -> void:
	var object_node:Area2D = object_scene.instantiate()
	object_node.position = attachement_position * object_displacement_multiplier + object_displacement
	placed_objects.append(object_node)
	add_sibling.call_deferred(object_node)

func draw_level(stage:int, level:int) -> void:
	print(placed_objects)
	for placed_object in placed_objects:
		placed_object.queue_free()
	placed_objects.clear()
	clear()
	var index = 0
	for row in stages[stage - 1][level - 1]:
		var level_length = stages[0][0].size()
		for cell in row:
			var coordinates:Vector2 = Vector2((index%level_length)-level_length/2, int(index/level_length)-level_length/2)
			set_cell(coordinates, 0, tile_types[cell])
			if object_types.has(cell):
				add_object(coordinates, object_types[cell])
			index += 1
			

func load_levels_file_content() -> void:
	var file = FileAccess.open("res://scripts/levels.txt", FileAccess.READ)
	var content = file.get_as_text()
	for stage in content.split("s"):
		var file_levels = []
		for level in stage.split("l"):
			var rows = []
			for row in level.split("\n"):
				if row != "":
					var cells = []
					for cell in row.split(","):
						cells.append(int(cell))
					rows.append(cells)
			if rows.size() > 0:
				file_levels.append(rows)
		stages.append(file_levels)
