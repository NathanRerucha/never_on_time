extends Node2D

func _ready() -> void:
	$Player.spawn_point = $Spawn.position
	$Player.shift_dist_past = 256
	$Player.shift_dist_future = 312
