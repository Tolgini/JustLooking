extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died
signal shot_arrows(arrows: Array)

@export var move_speed: float = 260.0
@export var arena_half_size: Vector2 = Vector2(590, 310)

var max_health: int = 5
var health: int = 5
var arrow_damage: int = 1
var arrow_speed: float = 760.0
var fire_rate: float = 1.75
var multishot: int = 1
var can_control: bool = false

var _shoot_cooldown: float = 0.0

@onready var bow: Line2D = $Bow
@onready var aim_line: Line2D = $AimLine

func _ready() -> void:
	reset_stats()

func reset_stats() -> void:
	max_health = 5
	health = max_health
	arrow_damage = 1
	arrow_speed = 760.0
	fire_rate = 1.75
	multishot = 1
	_shoot_cooldown = 0.0
	emit_signal("health_changed", health, max_health)

func _physics_process(delta: float) -> void:
	if not can_control:
		velocity = Vector2.ZERO
		return

	_shoot_cooldown = max(_shoot_cooldown - delta, 0.0)
	_handle_movement()
	_handle_aiming()

	if Input.is_action_pressed("shoot") and _shoot_cooldown <= 0.0:
		_shoot()

func _handle_movement() -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed
	move_and_slide()
	position.x = clampf(position.x, -arena_half_size.x, arena_half_size.x)
	position.y = clampf(position.y, -arena_half_size.y, arena_half_size.y)

func _handle_aiming() -> void:
	var aim_direction := (get_global_mouse_position() - global_position).normalized()
	if aim_direction == Vector2.ZERO:
		aim_direction = Vector2.RIGHT
	rotation = aim_direction.angle()
	# Keep the aim helper readable while the whole player rotates toward the cursor.
	aim_line.points = PackedVector2Array([Vector2.ZERO, Vector2(120, 0)])
	bow.rotation = PI / 2.0

func _shoot() -> void:
	var base_direction := Vector2.RIGHT.rotated(rotation).normalized()
	var spread_step := deg_to_rad(10.0)
	var start_index := -float(multishot - 1) / 2.0
	var arrows: Array = []
	for i in range(multishot):
		var direction := base_direction.rotated((start_index + i) * spread_step).normalized()
		arrows.append({
			"origin": global_position + direction * 34.0,
			"direction": direction,
			"damage": arrow_damage,
			"speed": arrow_speed
		})
	emit_signal("shot_arrows", arrows)
	_shoot_cooldown = 1.0 / fire_rate

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health = max(health - amount, 0)
	emit_signal("health_changed", health, max_health)
	if health == 0:
		can_control = false
		emit_signal("died")

func upgrade_damage() -> void:
	arrow_damage += 1

func upgrade_arrow_speed() -> void:
	arrow_speed += 120.0

func upgrade_max_health() -> void:
	max_health += 1
	health = min(health + 1, max_health)
	emit_signal("health_changed", health, max_health)

func upgrade_fire_rate() -> void:
	fire_rate += 0.35

func upgrade_multishot() -> void:
	multishot = min(multishot + 1, 5)
