extends Area2D

@onready var checkpoint = $"."

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if checkpoint.is_in_group("Past_Checkpoint"):	
			body.last_checkpoint = global_position
			body.current_time = 1
		elif checkpoint.is_in_group("Present_Checkpoint"):
			body.last_checkpoint = global_position
			body.current_time = 0
		print("Latest Checkpoint At: ", global_position)
		print("Current Time Period: ", body.current_time)
		# detect what group checkpoint node is in $ maybe
		# tell player what kind of checkpoint it is
		# player teleports to the corresponding checkpoint and sets correct time period
