extends StaticBody2D

@onready var platform = $"."

var player_on_platform = false

func _on_bottom_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		platform.set_collision_layer_value(1, false)

func _on_bottom_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		platform.set_collision_layer_value(1, true)
		body.velocity.y = 0

func _on_top_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_on_platform = true
		print("player on platform: ", player_on_platform)

func _on_top_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		platform.set_collision_layer_value(1, true)

func _process(_delta: float) -> void:
	if player_on_platform and Input.is_action_pressed("climb_ladder_down"):
			platform.set_collision_layer_value(1, false)
