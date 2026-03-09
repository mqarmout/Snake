extends CharacterBody2D

@onready var body_scene = preload("res://scenes/SnakeBody.tscn")

var speed = 15
var body_size:float = 6.5
var stationary:bool = true
var first_move:bool = true

var body_directions:Array[Vector2] = []
var body_parts:Array[CharacterBody2D] = []

var last_position:Vector2
var stored_direction:Vector2 = Vector2.ZERO
var current_direction:Vector2 = Vector2.ZERO

func getInput():
	var new_input = Input.get_vector("left", "right", "up", "down")
	if new_input != Vector2.ZERO:
		stationary = false
	if stored_direction != new_input && new_input != Vector2.ZERO:
		stored_direction = new_input
	if can_change_direction():
		determine_current_direction(stored_direction)
	if !stationary:move()

func determine_current_direction(new_input:Vector2) -> void:
	new_input = new_input.normalized().round()
	if new_input.abs() != Vector2.ONE && new_input != Vector2.ZERO:
		current_direction = new_input
	elif current_direction == Vector2.ZERO:
		current_direction = Vector2(new_input.x, 0)

func can_change_direction() -> bool:
	var distance:Vector2 = self.position - last_position
	if !stationary && stored_direction != Vector2.ZERO:
		if stored_direction != current_direction * -1:
			if first_move:
				last_position = self.position
				update_queue.call_deferred()
				first_move = false
				return true
			if distance.length() >= body_size:
				last_position = self.position
				update_queue.call_deferred()
				return true
	return false

func move() -> void:
	velocity = current_direction * speed

func update_queue() -> void:
	update_children()
	body_directions.reverse()
	body_directions.append(current_direction)
	body_directions.reverse()
	body_directions.pop_back()

func update_children() -> void:
	var index:int = 0
	for body in body_parts:
		body.movement_direction = body_directions.get(index)
		index += 1

func instantiate_body() -> void:
	last_position = self.position
	var index:int = 0
	for body_direction in body_directions:
		var initial_position:Vector2 = self.position
		if body_parts.size() > 0:
			initial_position = body_parts.get(index).position
		attach_new_body(initial_position, body_direction)
		index += 1

func attach_new_body(attachement_position:Vector2, direction:Vector2) -> void:
	var body_part:CharacterBody2D = body_scene.instantiate()
	body_part.position = attachement_position - (direction * body_size)
	body_parts.append(body_part)
	add_sibling.call_deferred(body_part)

func food_consumed() -> void:
	# rewrite to detect the object interacted with and act accordingly instead of waiting for a signal from the object
	var last_body_position: Vector2 = self.position if body_parts.size() == 0 else body_parts.back().position
	body_directions.append(Vector2.ZERO)
	attach_new_body(last_body_position, Vector2.ZERO)

func reset_location(location:Vector2, direction:Vector2):
	body_directions = []
	position = location + Vector2(body_size/2,body_size/2)
	for body in body_parts:
		body.queue_free()
	body_parts.clear()
	instantiate_body()

func stop_moving() -> void:
	first_move = true
	stationary = true
	current_direction = Vector2.ZERO
	stored_direction = Vector2.ZERO
	velocity = Vector2.ZERO

func _on_ready() -> void:
	instantiate_body()

func _physics_process(_delta):
	getInput()
	move_and_slide()
