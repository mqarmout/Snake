extends CharacterBody2D

@onready var body_scene = preload("res://scenes/SnakeBody.tscn")

var speed = 15
var cell_size: float = 8
var can_make_move: bool = true
var target: Vector2

var body_directions: Array[Vector2] = []
var body_parts: Array[CharacterBody2D] = []

var current_direction: Vector2 = Vector2.ZERO

func getInput(_delta: float):
	var new_input = Input.get_vector("left", "right", "up", "down").round()
	var direction: Vector2 = determine_direction(new_input)
	move(direction, _delta)

func move(direction: Vector2, _delta: float) -> void:
	if target == position && can_make_move:
		if direction != Vector2.ZERO:
			rotation = direction.angle()
		target = position + direction * cell_size
		can_make_move = false
	elif target == position && !can_make_move:
		can_make_move = true
	if !can_make_move:
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
		attach_new_body(initial_position, body_direction)
		index += 1

func update_queue() -> void:
	update_children()
	body_directions.reverse()
	body_directions.append(current_direction)
	body_directions.reverse()
	body_directions.pop_back()

func update_children() -> void:
	var index: int = 0
	for body in body_parts:
		body.movement_direction = body_directions.get(index)
		index += 1

func attach_new_body(attachement_position: Vector2, direction: Vector2) -> void:
	var body_part: CharacterBody2D = body_scene.instantiate()
	body_part.position = attachement_position - (direction * cell_size)
	body_parts.append(body_part)
	add_sibling.call_deferred(body_part)

func food_consumed() -> void:
	# rewrite to detect the object interacted with and act accordingly instead of waiting for a signal from the object
	var last_body_position: Vector2 = self.position if body_parts.size() == 0 else body_parts.back().position
	body_directions.append(Vector2.ZERO)
	attach_new_body(last_body_position, Vector2.ZERO)

func reset_location(location: Vector2, direction: Vector2):
	body_directions = []
	position = location + Vector2(cell_size/2,cell_size/2)
	target = position
	for body in body_parts:
		body.queue_free()
	body_parts.clear()
	instantiate_body()

func _on_ready() -> void:
	target = position
	instantiate_body()

func _physics_process(_delta):
	getInput(_delta)
	move_and_slide()
