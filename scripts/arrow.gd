extends Area2D

var direction := Vector2.RIGHT
var speed := 720.0
var damage := 10
var lifetime := 1.8

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	try_hit(area)

func _on_body_entered(body: Node) -> void:
	try_hit(body)

func try_hit(node: Node) -> void:
	if node.has_method("take_damage"):
		node.take_damage(damage)
		queue_free()
