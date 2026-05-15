extends Node2D

const PlayerScene := preload("res://scenes/Player.tscn")
const EnemyScene := preload("res://scenes/Enemy.tscn")
const UIScene := preload("res://scenes/UI.tscn")

var player
var ui
var wave := 1
var score := 0
var coins := 0
var enemies_alive := 0
var enemies_to_spawn := 0
var spawn_timer := 0.0
var game_started := false
var game_over := false

func _ready() -> void:
	show_start_screen()

func show_start_screen() -> void:
	var label := Label.new()
	label.name = "StartScreen"
	label.text = "JUST LOOKING: SHADOW ARCHER\n\nWASD = bewegen\nMaus = zielen\nLinksklick = schießen\nESC = Pause\n\nDrücke SPACE zum Starten"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(360, 210)
	label.add_theme_font_size_override("font_size", 32)
	add_child(label)

func _input(event: InputEvent) -> void:
	if not game_started and event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		start_game()
	elif game_over and event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()
	elif event.is_action_pressed("pause_game") and game_started and not game_over:
		get_tree().paused = not get_tree().paused

func start_game() -> void:
	game_started = true
	var start_screen = get_node_or_null("StartScreen")
	if start_screen:
		start_screen.queue_free()
	player = PlayerScene.instantiate()
	player.position = Vector2(640, 360)
	add_child(player)
	player.died.connect(_on_player_died)
	ui = UIScene.instantiate()
	add_child(ui)
	start_wave()

func _process(delta: float) -> void:
	if not game_started or game_over:
		return
	if enemies_to_spawn > 0:
		spawn_timer -= delta
		if spawn_timer <= 0.0:
			spawn_enemy()
			spawn_timer = max(0.25, 1.0 - wave * 0.05)
	if enemies_alive <= 0 and enemies_to_spawn <= 0:
		wave += 1
		apply_wave_upgrade()
		start_wave()
	update_ui()

func start_wave() -> void:
	enemies_to_spawn = 4 + wave * 2
	spawn_timer = 0.5

func spawn_enemy() -> void:
	enemies_to_spawn -= 1
	enemies_alive += 1
	var enemy = EnemyScene.instantiate()
	var side = randi() % 4
	if side == 0:
		enemy.position = Vector2(randf_range(0, 1280), -40)
	elif side == 1:
		enemy.position = Vector2(randf_range(0, 1280), 760)
	elif side == 2:
		enemy.position = Vector2(-40, randf_range(0, 720))
	else:
		enemy.position = Vector2(1320, randf_range(0, 720))
	enemy.target = player
	enemy.health = 20 + wave * 6
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)

func _on_enemy_died() -> void:
	enemies_alive -= 1
	score += 100
	coins += 5

func apply_wave_upgrade() -> void:
	# Erste einfache Upgrade-Logik: alle Wellen wird der Spieler stärker.
	player.damage += 2
	player.arrow_speed += 20
	if wave % 3 == 0:
		player.max_health += 1
		player.health = player.max_health

func update_ui() -> void:
	if ui and player:
		ui.update_values(player.health, player.max_health, wave, score, coins)

func _on_player_died() -> void:
	game_over = true
	var label := Label.new()
	label.text = "GAME OVER\nScore: %s\nWave: %s\n\nDrücke R zum Neustart" % [score, wave]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(430, 260)
	label.add_theme_font_size_override("font_size", 36)
	add_child(label)
