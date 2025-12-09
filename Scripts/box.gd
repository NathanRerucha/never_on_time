# https://www.youtube.com/watch?v=vH-92ctgnMM
# https://forum.godotengine.org/t/push-object-jitter/90478

extends CharacterBody2D

var push : bool = false
var direction : int = 0
var acceleration : float = 50
var braking : float = 15
@export var push_speed : float = 50

var box_pos : Vector2 = global_position
var player_pos : Vector2
var pulling_direction : float = box_pos.direction_to(player_pos).x

func _physics_process(delta: float) -> void:
	var target_velocity_x = (direction * push_speed)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if push:
		velocity.x = lerp(velocity.x, target_velocity_x, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, target_velocity_x, braking * delta)
	move_and_slide()

func _on_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pos = body.global_position
		direction = 1
		push = true


func _on_left_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pos = body.global_position
		print("exit")
		direction = 0
		push = false


func _on_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pos = body.global_position
		direction = -1
		push = true


func _on_right_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pos = body.global_position
		direction = 0
		push = false
