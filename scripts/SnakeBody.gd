extends CharacterBody2D

var speed = 15
var target: Vector2

func move(_delta: float):
	position = position.move_toward(target, _delta * speed)

func _physics_process(_delta):
	move(_delta)
	move_and_slide()

func _on_ready() -> void:
	target = position
