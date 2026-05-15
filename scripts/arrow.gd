extends Area2D

@export var lifetime: float = 1.4

var damage: int = 1
var velocity: Vector2 = Vector2.RIGHT * 760.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	rotation = velocity.angle()

func setup(origin: Vector2, direction: Vector2, arrow_damage: int, arrow_speed: float) -> void:
	global_position = origin
	damage = arrow_damage
	velocity = direction.normalized() * arrow_speed
	rotation = velocity.angle()

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
