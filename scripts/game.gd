extends Node2D

const ArrowScene := preload("res://scenes/Arrow.tscn")
const EnemyScene := preload("res://scenes/Enemy.tscn")

var wave: int = 0
var score: int = 0
var coins: int = 0
var enemies_remaining: int = 0
var game_state: String = "menu"
var _current_health: int = 5
var _current_max_health: int = 5

@onready var player: CharacterBody2D = $Player
@onready var arrows: Node2D = $Arrows
@onready var enemies: Node2D = $Enemies
@onready var ui: CanvasLayer = $UI

func _ready() -> void:
	randomize()
	player.can_control = false
	player.shot_arrows.connect(_on_player_shot_arrows)
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	ui.start_requested.connect(start_game)
	ui.resume_requested.connect(_resume_game)
	ui.restart_requested.connect(start_game)
	ui.upgrade_selected.connect(_apply_upgrade)
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if game_state == "playing":
			_pause_game()
		elif game_state == "paused":
			_resume_game()

func start_game() -> void:
	get_tree().paused = false
	_clear_children(arrows)
	_clear_children(enemies)
	wave = 0
	score = 0
	coins = 0
	enemies_remaining = 0
	player.position = Vector2.ZERO
	player.rotation = 0.0
	player.reset_stats()
	player.can_control = true
	_start_next_wave()
	ui.show_playing()
	game_state = "playing"
	_update_hud()

func _start_next_wave() -> void:
	wave += 1
	enemies_remaining = 4 + wave * 2
	for i in range(enemies_remaining):
		_spawn_enemy(i)
	_update_hud()

func _spawn_enemy(index: int) -> void:
	var enemy := EnemyScene.instantiate()
	var angle := TAU * float(index) / float(max(enemies_remaining, 1)) + randf_range(-0.18, 0.18)
	var radius := 430.0 + randf_range(0.0, 80.0)
	enemy.position = Vector2(cos(angle), sin(angle)) * radius
	enemy.configure(wave, player)
	enemy.died.connect(_on_enemy_died)
	enemies.add_child(enemy)

func _on_player_shot_arrows(arrow_configs: Array) -> void:
	if game_state != "playing":
		return
	for config in arrow_configs:
		var arrow := ArrowScene.instantiate()
		arrows.add_child(arrow)
		arrow.setup(config["origin"], config["direction"], config["damage"], config["speed"])

func _on_enemy_died(_enemy: Node, score_value: int, coin_value: int) -> void:
	score += score_value
	coins += coin_value
	enemies_remaining -= 1
	_update_hud()
	if enemies_remaining <= 0 and game_state == "playing":
		player.can_control = false
		game_state = "upgrade"
		ui.show_upgrade(wave)

func _apply_upgrade(upgrade_id: String) -> void:
	match upgrade_id:
		"damage":
			player.upgrade_damage()
		"arrow_speed":
			player.upgrade_arrow_speed()
		"health":
			player.upgrade_max_health()
		"fire_rate":
			player.upgrade_fire_rate()
		"multishot":
			player.upgrade_multishot()
	player.can_control = true
	game_state = "playing"
	ui.show_playing()
	_start_next_wave()

func _pause_game() -> void:
	game_state = "paused"
	player.can_control = false
	get_tree().paused = true
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	ui.show_pause()

func _resume_game() -> void:
	get_tree().paused = false
	game_state = "playing"
	player.can_control = true
	ui.show_playing()

func _on_player_health_changed(current: int, maximum: int) -> void:
	_current_health = current
	_current_max_health = maximum
	_update_hud()

func _on_player_died() -> void:
	get_tree().paused = false
	game_state = "game_over"
	player.can_control = false
	ui.show_game_over(score, wave)

func _update_hud() -> void:
	if ui != null:
		ui.update_hud(_current_health, _current_max_health, coins, wave, score)

func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
