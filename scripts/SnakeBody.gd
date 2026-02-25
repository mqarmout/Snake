extends CharacterBody2D

var speed = 15
var movement_direction: Vector2 = Vector2.ZERO

func move():
	velocity = movement_direction * speed

func _physics_process(_delta):
	move()
	move_and_slide()
