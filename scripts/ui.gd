extends CanvasLayer

@onready var label: Label = $Label

func update_values(health: int, max_health: int, wave: int, score: int, coins: int) -> void:
	label.text = "HP: %s/%s   Wave: %s   Score: %s   Coins: %s" % [health, max_health, wave, score, coins]
