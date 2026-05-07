extends TileMapLayer

@onready var Food_Scene = preload("res://scenes/Food.tscn")
@onready var exit_scene = preload("res://scenes/Exit.tscn")

var object_displacement: Vector2 = Vector2(4,4)
var object_displacement_multiplier: int = 8
var placed_objects: Dictionary[int,Array]
var cell_size: int = 8

var stages = []
var stage_interactables = []
var level_start_coordinates = []
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

func setup_objects_dictionary() -> void:
	object_types = {
		3: exit_scene,
		4: Food_Scene
	}

func free_object(_object: Area2D, level: int):
	var index:int = 0
	for placed_object in placed_objects[level]:
		if placed_object == _object:
			placed_objects[level].pop_at(index)
			_object.queue_free()
			return
		index += 1

func clear_level(level: int) -> void:
	for placed_object in placed_objects[level]:
		placed_object.queue_free()
	placed_objects[level].clear()

func add_object(attachement_position: Vector2, object_scene: PackedScene, level: int) -> void:
	var object_node: Area2D = object_scene.instantiate()
	object_node.position = attachement_position * object_displacement_multiplier + object_displacement
	if !placed_objects.has(level):
		placed_objects[level] = []
	placed_objects[level].append(object_node)
	add_sibling.call_deferred(object_node)

func place_interactables(level: int) -> void:
	var start_coordinate = level_start_coordinates[level - 1]
	for level_interactable in stage_interactables[level - 1]:
		if object_types.has(level_interactable[1]):
			add_object(start_coordinate + level_interactable[0], object_types[level_interactable[1]], level)

func draw_level(stage: int, level: int) -> void:
	var index = 0
	var start_coordinate = level_start_coordinates[level - 1]
	for row in stages[stage - 1][level - 1]:
		var level_length = stages[stage - 1][level - 1].size()
		for cell in row:
			var coordinates: Vector2 = start_coordinate + Vector2(int(index/level_length), int(index%level_length))
			set_cell(coordinates, 0, tile_types[cell])
			index += 1

func draw_all_levels(stage: int) -> void:
	for level in stages[stage - 1].size():
		draw_level(stage, level + 1)
		place_interactables(level + 1)

func load_stage(stage: int) -> void:
	var file = FileAccess.open("res://stages/stage_%s.txt" % stage, FileAccess.READ)
	var content = file.get_as_text()
	var found_stages: Array = content.split("s")
	found_stages.pop_back()
	
	for found_stage in found_stages:
		var levels: Array
		var lines: Array = found_stage.split("\n")
		var counter: int = 0
		while counter < lines.size() - 1:
			level_start_coordinates.append(Vector2(int(lines[counter].split(",")[0]), int(lines[counter].split(",")[1])))
			var level_dimensions: Vector2 = Vector2(int(lines[counter+1].split(",")[0]), int(lines[counter+1].split(",")[1]))

			var objects: Array = lines[counter + 2].split(",")
			var objects_counter: int = 0
			while objects_counter < objects.size():
				objects.append(int(objects[0]))
				objects.pop_front()
				objects_counter += 1
			
			var objects_locations: Array
			var split_objects_locations: Array = lines[counter + 3].split(",")
			objects_counter =  0
			while objects_counter < split_objects_locations.size():
				objects_locations.append(Vector2(int(split_objects_locations[objects_counter]), int(split_objects_locations[objects_counter + 1])))
				objects_counter += 2
			
			var new_level: Array
			for col in level_dimensions.y:
				var new_line: Array
				new_line.resize(int(level_dimensions.x))
				if col == 0 || col == level_dimensions.y - 1:
					new_line.fill(1)
				else:
					new_line.fill(0)
					new_line[0] = 1
					new_line[level_dimensions.x - 1] = 1
				new_level.append(new_line)
			
			objects_counter = 0
			var level_interactables = []
			for _object in objects:
				new_level[objects_locations[objects_counter].x][objects_locations[objects_counter].y] = _object
				level_interactables.append([objects_locations[objects_counter],_object])
				objects_counter += 1
			levels.append(new_level)
			stage_interactables.append(level_interactables)
			
			counter += 4
		stages.append(levels)

func get_current_level_center(stage: int, level: int) -> Vector2:
	var horizontal_level_length = stages[stage - 1][level - 1][0].size()
	var vertical_level_length = stages[stage - 1][level - 1].size()
	return level_start_coordinates[level - 1] * cell_size + Vector2(horizontal_level_length * cell_size / 2, vertical_level_length * cell_size / 2)

func update_stage_text_file() -> void:
	print("saving changes")
	var used_cells :Array = self.get_used_cells()
	var current_map: Array = []
	for cell in used_cells:
		current_map
	print(current_map)
	print(stages[0][0])
