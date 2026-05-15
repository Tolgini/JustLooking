extends CharacterBody2D

signal died

const ArrowScene := preload("res://scenes/Arrow.tscn")

var speed := 260.0
var health := 5
var max_health := 5
var damage := 12
var arrow_speed := 720.0
var fire_cooldown := 0.35
var fire_timer := 0.0

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input_vector.normalized() * speed
	move_and_slide()
	look_at(get_global_mouse_position())
	fire_timer -= delta
	if Input.is_action_pressed("shoot") and fire_timer <= 0.0:
		shoot()
		fire_timer = fire_cooldown

func shoot() -> void:
	var arrow = ArrowScene.instantiate()
	arrow.global_position = global_position + Vector2.RIGHT.rotated(rotation) * 26
	arrow.rotation = rotation
	arrow.direction = Vector2.RIGHT.rotated(rotation)
	arrow.speed = arrow_speed
	arrow.damage = damage
	get_parent().add_child(arrow)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit()
		queue_free()
