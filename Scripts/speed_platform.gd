extends StaticBody2D

@export var speed_multiplier: float = 2.0

func _on_speed_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("apply_speed_modifier"):
			body.apply_speed_modifier(speed_multiplier)


func _on_speed_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("remove_speed_modifier"):
			body.remove_speed_modifier()
