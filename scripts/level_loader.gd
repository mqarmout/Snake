extends Node
#
#func load_stage(stage: int) -> Array:
	#var level_start_coordinates: Array
	#var stage_interactables: Array
	#var stages: Array
	#
	#var file = FileAccess.open("res://stages/stage_%s.txt" % stage, FileAccess.READ)
	#var content = file.get_as_text()
	#var found_stages: Array = content.split("s")
	#found_stages.pop_back()
	#
	#for found_stage in found_stages:
		#var levels: Array
		#var lines: Array = found_stage.split("\n")
		#var counter: int = 0
		#while counter < lines.size() - 1:
			#level_start_coordinates.append(Vector2(int(lines[counter].split(",")[0]), int(lines[counter].split(",")[1])))
			#var level_dimensions: Vector2 = Vector2(int(lines[counter+1].split(",")[0]), int(lines[counter+1].split(",")[1]))
#
			#var objects: Array = lines[counter + 2].split(",")
			#var objects_counter: int = 0
			#while objects_counter < objects.size():
				#objects.append(int(objects[0]))
				#objects.pop_front()
				#objects_counter += 1
			#
			#var objects_locations: Array
			#var split_objects_locations: Array = lines[counter + 3].split(",")
			#objects_counter =  0
			#while objects_counter < split_objects_locations.size():
				#objects_locations.append(Vector2(int(split_objects_locations[objects_counter]), int(split_objects_locations[objects_counter + 1])))
				#objects_counter += 2
			#
			#var new_level: Array
			#for col in level_dimensions.y:
				#var new_line: Array
				#new_line.resize(int(level_dimensions.x))
				#if col == 0 || col == level_dimensions.y - 1:
					#new_line.fill(1)
				#else:
					#new_line.fill(0)
					#new_line[0] = 1
					#new_line[level_dimensions.x - 1] = 1
				#new_level.append(new_line)
			#
			#objects_counter = 0
			#var level_interactables = []
			#for _object in objects:
				#new_level[objects_locations[objects_counter].x][objects_locations[objects_counter].y] = _object
				#level_interactables.append([objects_locations[objects_counter],_object])
				#objects_counter += 1
			#levels.append(new_level)
			#stage_interactables.append(level_interactables)
			#
			#counter += 4
		#stages.append(levels)
	#return []
