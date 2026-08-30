extends CharacterBody2D

@onready var body_scene = preload("res://scenes/SnakeBody.tscn")
@onready var game_manager: Node2D = $"../GameManager"

const SPEED := 15
const CELL_SIZE := 8

var body_directions: Array[Vector2] = []
var body_parts: Array[CharacterBody2D] = []

var current_direction := Vector2.ZERO
var last_direction: Vector2
var died: bool = false
var can_make_move := true
var target: Vector2

var pending_food_position: Vector2
var has_pending_food := false

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
	if target == position and can_make_move and current_direction != Vector2.ZERO:
		rotation = current_direction.angle()
		target = position + current_direction * CELL_SIZE
		last_direction = current_direction
		current_direction = Vector2.ZERO
		can_make_move = false
		update_children()
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

func update_children() -> void:
	body_directions.push_front(last_direction)
	if has_pending_food:
		attach_new_body()
		body_directions.push_front(Vector2.ZERO)
		has_pending_food = false
	body_directions.pop_back()
	var index: int = 0
	for body in body_parts:
		var body_direction: Vector2 = body_directions.get(index)
		body.target = body.position + body_direction * CELL_SIZE
		body.rotation = body_direction.angle()
		body.set_collision_layer_value(3, true if index > 0 else false)
		index += 1

func attach_new_body() -> void:
	var body_part: CharacterBody2D = body_scene.instantiate()
	body_part.position = pending_food_position
	body_part.rotation = rotation
	body_parts.push_front(body_part)
	add_sibling.call_deferred(body_part)

func food_consumed() -> void:
	pending_food_position = target - last_direction * CELL_SIZE
	has_pending_food = true

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
		body.set_collision_layer_value(3, false)
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
	target = target + last_direction * CELL_SIZE
	take_step(get_process_delta_time())

func _on_ready() -> void:
	target = position
	reset_position = position
