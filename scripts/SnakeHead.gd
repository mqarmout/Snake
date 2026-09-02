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
		body_directions.push_front(current_direction)
		rotation = current_direction.angle()
		target = position + current_direction * CELL_SIZE
		current_direction = Vector2.ZERO
		can_make_move = false
		if has_pending_food:
			attach_new_body(target - body_directions.front() * CELL_SIZE)
			has_pending_food = false
		else:
			update_children()
	elif target == position and !can_make_move:
		can_make_move = true
	if !can_make_move:
		died = false
	position = position.move_toward(target, delta * SPEED)

func determine_direction(new_input: Vector2) -> Vector2:
	var direction = body_directions.front() if body_directions.size() > 0 else Vector2.RIGHT
	if new_input == direction * -1 or new_input == Vector2.ZERO:
		return Vector2.ZERO
	if new_input.abs() == Vector2.ONE:
		return (direction.abs() - new_input.abs()) * new_input
	return new_input

func update_children() -> void:
	var index: int = 1
	for body in body_parts:
		var body_direction: Vector2 = body_directions.get(index)
		if body_direction != Vector2.ZERO: body.rotation = body_direction.angle()
		body.target = body.position + body_direction * CELL_SIZE
		body.set_collision_layer_value(6, false if index == 1 or index == body_parts.size() else true)
		index += 1

	while body_directions.size() > body_parts.size() + 1:
		body_directions.pop_back()

func attach_new_body(body_position: Vector2) -> void:
	var body_part: CharacterBody2D = body_scene.instantiate()
	body_part.position = body_position
	body_part.rotation = rotation
	body_part.set_collision_layer_value(6, false)
	if body_parts.size() == 0: body_part.modulate = Color(0.0, 0.0, 0.0, 1.0)
	body_parts.push_front(body_part)
	add_sibling.call_deferred(body_part)

func food_consumed() -> void:
	pass

func reset_head():
	died = true
	suppress_until_release = true
	position = reset_position
	current_direction = Vector2.ZERO
	rotation = reset_direction.angle()
	target = position
	body_directions = []
	for body in body_parts:
		body.free()
	body_parts.clear()
	has_pending_food = false

func drop_body() -> void:
	for body in body_parts:
		body.set_physics_process(false)
		body.set_collision_layer_value(6, false)
	body_directions = []
	body_parts.clear()
	has_pending_food = false

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name.to_lower().contains("exit") and !died:
		reset_direction = body_directions.front() if body_directions.size() > 0 else Vector2.RIGHT
		drop_body()

func check_collisions():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider_name: String = collision.get_collider().name.to_lower()
		if collider_name.contains("levelmanager") or collider_name.contains("snakebody"):
			reset_head()
			game_manager.reset_level()
			return
		if collider_name.contains("food") or collider_name.contains("rat"):
			has_pending_food = true
			game_manager.food_consumed(collision.get_collider())

func level_cleared() -> void:
	var direction = body_directions.front() if body_directions.size() > 0 else Vector2.RIGHT
	rotation = direction.angle()
	target = target + direction * CELL_SIZE

func _on_ready() -> void:
	target = position
	reset_position = position
