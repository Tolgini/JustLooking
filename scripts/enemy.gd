extends CharacterBody2D

signal died(enemy: Node, score_value: int, coin_value: int)

@export var speed: float = 95.0
@export var max_health: int = 2
@export var damage: int = 1
@export var score_value: int = 10
@export var coin_value: int = 1
@export var attack_range: float = 36.0
@export var attack_delay: float = 0.85

var target: Node2D
var health: int
var _attack_timer: float = 0.0

@onready var body: Polygon2D = $Body

func _ready() -> void:
	health = max_health
	_update_color()

func configure(wave: int, player: Node2D) -> void:
	target = player
	max_health = 1 + int(wave / 2.0)
	health = max_health
	speed = 82.0 + wave * 6.0
	score_value = 8 + wave * 2
	coin_value = 1 + int(wave / 4.0)
	_update_color()

func _physics_process(delta: float) -> void:
	if target == null or health <= 0:
		return
	_attack_timer = max(_attack_timer - delta, 0.0)
	var direction := (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(target.global_position) <= attack_range and _attack_timer <= 0.0:
		_attack_timer = attack_delay
		if target.has_method("take_damage"):
			target.take_damage(damage)

func take_damage(amount: int) -> void:
	health -= amount
	_update_color()
	if health <= 0:
		emit_signal("died", self, score_value, coin_value)
		queue_free()

func _update_color() -> void:
	if body == null:
		return
	var health_ratio := 1.0 if max_health <= 0 else clampf(float(health) / float(max_health), 0.0, 1.0)
	body.color = Color(0.55 + (1.0 - health_ratio) * 0.35, 0.08, 0.18, 1.0)
