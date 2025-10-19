extends Node2D

func _ready() -> void:
	$Player.shift_dist = 288

func _on_kill_zone_area_entered(area: Area2D) -> void:
	$Player.position = $Spawn.position
