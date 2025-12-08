extends StaticBody2D

@onready var platform = $"."

func _on_bottom_zone_body_entered(body: Node2D) -> void:
	pass

func _on_bottom_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_top_zone_body_entered(body: Node2D) -> void:
	print("on platform")


func _on_top_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_pressed("climb_ladder_down"):
		print(collision_layer)
		platform.collision_layer = 3
		platform.collision_mask = 3
		print(collision_layer)
