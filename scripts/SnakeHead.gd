extends CharacterBody2D

@onready var body_scene = preload("res://scenes/SnakeBody.tscn")
@onready var game_manager: Node2D = $"../GameManager"

var speed = 15
var cell_size: float = 8
var can_make_move: bool = true
var target: Vector2

var body_directions: Array[Vector2] = []
var body_parts: Array[CharacterBody2D] = []

var current_direction: Vector2 = Vector2.ZERO
var reset_location: Vector2
var reset_rotation: int
var died: bool = false

func getInput(_delta: float):
	var new_input = Input.get_vector("left", "right", "up", "down").round()
	var direction: Vector2 = determine_direction(new_input)
	if new_input != Vector2.ZERO || target != position: move(direction, _delta)

func move(direction: Vector2, _delta: float) -> void:
	if target == position and can_make_move:
		if direction != Vector2.ZERO:
			rotation = direction.angle()
			update_queue()
		target = position + direction * cell_size
		can_make_move = false
	elif target == position and !can_make_move:
		can_make_move = true
	if !can_make_move:
		died = false
		position = position.move_toward(target, _delta * speed)

func determine_direction(new_input: Vector2) -> Vector2:
	current_direction = Vector2(cos(rotation), sin(rotation))
	if new_input == current_direction * -1:
		return Vector2.ZERO
	if new_input.abs() == Vector2.ONE:
		print((current_direction.abs() - new_input.abs()) * new_input)
		return (current_direction.abs() - new_input.abs()) * new_input
	return new_input

func instantiate_body() -> void:
	var index: int = 0
	for body_direction in body_directions:
		var initial_position: Vector2 = self.position
		if body_parts.size() > 0:
			initial_position = body_parts.get(index).position
		attach_new_body(initial_position)
		index += 1

func update_queue() -> void:
	body_directions.reverse()
	body_directions.append(current_direction)
	body_directions.reverse()
	body_directions.pop_back()
	update_children()

func update_children() -> void:
	var index: int = 0
	for body in body_parts:
		var body_direction: Vector2 = body_directions.get(index)
		var new_body_part_target = body.position + body_direction * cell_size
		body.target = new_body_part_target
		body.rotation = body_direction.angle()
		index += 1

func attach_new_body(attachement_position: Vector2) -> void:
	var body_part: CharacterBody2D = body_scene.instantiate()
	body_part.position = attachement_position
	body_part.rotation = rotation
	body_parts.append(body_part)
	add_sibling.call_deferred(body_part)

func food_consumed() -> void:
	var last_body_position: Vector2 = target if body_parts.size() == 0 else body_parts.back().target
	var direction: Vector2 = current_direction if body_parts.size() == 0 else body_directions.back()
	var new_body_part_position = last_body_position - direction * cell_size
	print(last_body_position)
	body_directions.append(Vector2.ZERO)
	attach_new_body(new_body_part_position)

func reset_head():
	died = true
	position = reset_location
	current_direction = Vector2(cos(rotation), sin(rotation))
	rotation = reset_rotation
	target = position
	reset_body()

func reset_body() -> void:
	body_directions = []
	for body in body_parts:
		body.queue_free()
	body_parts.clear()
	instantiate_body()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "LevelManager":
		reset_head()
	if body.name == "SnakeBody":
		reset_head()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.contains("Food"):
		food_consumed()
		game_manager.food_consumed(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name.contains("Exit") and !died:
		reset_location = area.position + current_direction * cell_size
		reset_rotation = int(rotation)
		game_manager.level_cleared()
		reset_body()

func _on_ready() -> void:
	target = position
	reset_location = position
	reset_rotation = int(rotation)
	instantiate_body()

func _physics_process(_delta):
	getInput(_delta)
	move_and_slide()
