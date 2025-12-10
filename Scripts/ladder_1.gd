extends Sprite2D

@onready var platform = $SelectivePlatform

@export var disable_platform = false

func _ready() -> void:
	if disable_platform:
		remove_child($SelectivePlatform)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.on_ladder = true
		print("ladder")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("exit ladder")
		if not disable_platform:
			body.is_climbing = false
			body.on_ladder = false
			
