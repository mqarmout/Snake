extends CharacterBody2D

enum AttackType {NONE, SPEAR, GLAVE, BOW}
enum DefenseType {NONE, FRONT, REAR}

@export var health := 1
@export var direction: Vector2
@export var attack_type: AttackType = AttackType.NONE
@export var rat_defense_type: DefenseType = DefenseType.NONE

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("snake"):
		body.reset_head()
		GameManager.reset_level()

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
	rotation = direction.angle()
	if attack_type == AttackType.NONE:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
