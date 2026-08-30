extends CharacterBody2D

@onready var body_scene = preload("res://scenes/SnakeBody.tscn")
@onready var game_manager: Node2D = $"../GameManager"

const SPEED := 15
const CELL_SIZE := 8

var body_directions: Array[Vector2] = []
var body_parts: Array[CharacterBody2D] = []

var current_direction := Vector2.ZERO
var died: bool = false
var can_make_move := true
var target: Vector2

var reset_position = Vector2.ZERO
var reset_direction := Vector2.RIGHT
var suppress_until_release := false

func _physics_process(delta):
	read_input()
	take_step(delta)
	move_and_slide()
	check_collisions()

func read_input():
	var new_input = Input.get_vector("left", "right", "up", "down").round()
	if new_input == Vector2.ZERO:
		suppress_until_release = false
		current_direction = Vector2.ZERO
		return
	if suppress_until_release:
		return
	current_direction = determine_direction(new_input)

func take_step(delta: float) -> void:
	if target == position and can_make_move:
		if current_direction != Vector2.ZERO:
			rotation = current_direction.angle()
			update_queue()
		target = position + current_direction * CELL_SIZE
		current_direction = Vector2.ZERO
		can_make_move = false
	elif target == position and !can_make_move:
		can_make_move = true
	if !can_make_move:
		died = false
	position = position.move_toward(target, delta * SPEED)

func determine_direction(new_input: Vector2) -> Vector2:
	if new_input == current_direction * -1 or new_input == Vector2.ZERO:
		return Vector2.ZERO
	if new_input.abs() == Vector2.ONE:
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
		var new_body_part_target = body.position + body_direction * CELL_SIZE
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
	var new_body_part_position = last_body_position - direction * CELL_SIZE
	body_directions.append(Vector2.ZERO)
	attach_new_body(new_body_part_position)

func reset_head():
	died = true
	suppress_until_release = true
	position = reset_position
	current_direction = Vector2.ZERO
	rotation = reset_direction.angle()
	target = position
	drop_body()

func drop_body() -> void:
	for body in body_parts:
		body.set_physics_process(false)
		body.set_collision_layer_value(1, false)
		body.set_collision_mask_value(1, false)
	body_directions = []
	body_parts.clear()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name.to_lower().contains("exit") and !died:
		reset_direction = current_direction
		drop_body()

func check_collisions():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider().name.to_lower().contains("levelmanager"):
			reset_head()
			game_manager.reset_level()
		if collision.get_collider().name.to_lower().contains("food"):
			food_consumed()
			game_manager.food_consumed(collision.get_collider())
		if collision.get_collider().name.contains("SnakeBody"):
			reset_head()
			game_manager.reset_level()

func level_cleared() -> void:
	target = target + reset_direction * CELL_SIZE
	take_step(get_process_delta_time())

func _on_ready() -> void:
	target = position
	reset_position = position
	instantiate_body()
