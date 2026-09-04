extends CharacterBody2D

enum AttackType {NONE, SPEAR, GLAVE, BOW}
enum DefenseType {NONE, FRONT, REAR}
enum Directions {UP, RIGHT, DOWN, LEFT}

const DIRECTIONS_VECTORS := {
	Directions.UP : Vector2.UP,
	Directions.RIGHT : Vector2.RIGHT,
	Directions.DOWN : Vector2.DOWN,
	Directions.LEFT : Vector2.LEFT}

@export var health := 1
@export var direction: Directions
@export var attack_type: AttackType = AttackType.NONE
@export var rat_defense_type: DefenseType = DefenseType.NONE

var head_detected := false
var attack := false
var detected_objects : Array[CharacterBody2D]

func update_entity() -> void:
	if (attack && not attack_type == AttackType.NONE) and detected_objects.size() > 0:
		detected_objects.front().take_damage()
	attack = false
	if head_detected:
		head_detected = false
		attack = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	head_detected = true
	detected_objects.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	detected_objects.pop_front()

func interact() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func reset_node() -> void:
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	if attack_type == AttackType.NONE:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	else:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)

func _on_ready() -> void:
	rotation = DIRECTIONS_VECTORS[direction].angle()
	if attack_type == AttackType.NONE:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
