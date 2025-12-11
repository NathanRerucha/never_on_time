extends Node2D

@onready var player = $Player

var power_is_on : bool = false

func _ready() -> void:
	player.shift_dist = -2858

func _process(_delta: float) -> void:
	if Globals.remove_elevator_killzone:
		$ElevatorKillZone.queue_free()
		$ElevatorKillZone2.queue_free()
		Globals.remove_elevator_killzone = false
		print("Removed Killzones")
