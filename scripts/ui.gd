extends CanvasLayer

signal start_requested
signal resume_requested
signal restart_requested
signal upgrade_selected(upgrade_id: String)

@onready var hud: Control = $HUD
@onready var health_label: Label = $HUD/Stats/HealthLabel
@onready var coins_label: Label = $HUD/Stats/CoinsLabel
@onready var wave_label: Label = $HUD/Stats/WaveLabel
@onready var score_label: Label = $HUD/Stats/ScoreLabel
@onready var hint_label: Label = $HUD/HintLabel
@onready var start_menu: Control = $StartMenu
@onready var pause_menu: Control = $PauseMenu
@onready var upgrade_menu: Control = $UpgradeMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var final_score_label: Label = $GameOverMenu/Panel/VBox/FinalScoreLabel

func _ready() -> void:
	$StartMenu/Panel/VBox/StartButton.pressed.connect(func() -> void: emit_signal("start_requested"))
	$PauseMenu/Panel/VBox/ResumeButton.pressed.connect(func() -> void: emit_signal("resume_requested"))
	$PauseMenu/Panel/VBox/RestartButton.pressed.connect(func() -> void: emit_signal("restart_requested"))
	$GameOverMenu/Panel/VBox/RestartButton.pressed.connect(func() -> void: emit_signal("restart_requested"))
	$UpgradeMenu/Panel/VBox/DamageButton.pressed.connect(func() -> void: emit_signal("upgrade_selected", "damage"))
	$UpgradeMenu/Panel/VBox/ArrowSpeedButton.pressed.connect(func() -> void: emit_signal("upgrade_selected", "arrow_speed"))
	$UpgradeMenu/Panel/VBox/HealthButton.pressed.connect(func() -> void: emit_signal("upgrade_selected", "health"))
	$UpgradeMenu/Panel/VBox/FireRateButton.pressed.connect(func() -> void: emit_signal("upgrade_selected", "fire_rate"))
	$UpgradeMenu/Panel/VBox/MultishotButton.pressed.connect(func() -> void: emit_signal("upgrade_selected", "multishot"))
	show_start_menu()

func update_hud(health: int, max_health: int, coins: int, wave: int, score: int) -> void:
	health_label.text = "Leben: %d/%d" % [health, max_health]
	coins_label.text = "Coins: %d" % coins
	wave_label.text = "Wave: %d" % wave
	score_label.text = "Score: %d" % score

func show_start_menu() -> void:
	_show_only(start_menu)
	hud.visible = false

func show_playing() -> void:
	_show_only(null)
	hud.visible = true
	hint_label.text = "WASD bewegen • Maus zielen • Linksklick schießen • Esc/P pausieren"

func show_pause() -> void:
	_show_only(pause_menu)
	hud.visible = true

func show_upgrade(wave: int) -> void:
	_show_only(upgrade_menu)
	hud.visible = true
	$UpgradeMenu/Panel/VBox/TitleLabel.text = "Wave %d überlebt - Upgrade wählen" % wave

func show_game_over(score: int, wave: int) -> void:
	_show_only(game_over_menu)
	hud.visible = true
	final_score_label.text = "Score: %d  •  Erreichte Wave: %d" % [score, wave]

func _show_only(menu: Control) -> void:
	start_menu.visible = menu == start_menu
	pause_menu.visible = menu == pause_menu
	upgrade_menu.visible = menu == upgrade_menu
	game_over_menu.visible = menu == game_over_menu
