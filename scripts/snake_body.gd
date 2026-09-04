extends CharacterBody2D

var speed = 15
var target: Vector2
var direction: Vector2
var snake_head: CharacterBody2D

func take_damage() -> void:
	if not snake_head == null:
		snake_head.detatch_body(self)

func move(_delta: float):
	position = position.move_toward(target, _delta * speed)

func _physics_process(_delta):
	move(_delta)

func _on_ready() -> void:
	name = "SnakeBody"
	target = position
