extends CharacterBody2D

signal died

var target: Node2D
var speed := 95.0
var health := 30
var touch_damage := 1
var hit_timer := 0.0

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	var direction := (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	look_at(target.global_position)
	hit_timer -= delta
	if global_position.distance_to(target.global_position) < 34 and hit_timer <= 0.0:
		if target.has_method("take_damage"):
			target.take_damage(touch_damage)
		hit_timer = 0.8

func take_damage(amount: int) -> void:
	health -= amount
	modulate = Color(1, 1, 1, 1)
	if health <= 0:
		died.emit()
		queue_free()
