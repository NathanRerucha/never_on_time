extends Node2D

@onready var player = $Player

var power_is_on : bool = false

func _ready() -> void:
	player.shift_dist = -2859
	
func _on_lv_1_generator_past_power_on() -> void:
	power_is_on = true
