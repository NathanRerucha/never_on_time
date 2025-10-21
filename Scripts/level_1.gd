extends Node2D

func _ready() -> void:
	$Player.spawn_point = $Spawn.position
	$Player.shift_dist = 288
