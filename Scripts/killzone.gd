extends Area2D

@onready var timer = $Timer

# removed body paramaters type to avoid errors
# and simplified the logic, don't really know if we need the timer or not
func _on_body_entered(body) -> void:
#	timer.start()
	# to test if the thing that has entered is a CharacterBody2D
	if body.get_class() == "CharacterBody2D":
		# if yes, reload scene using call deffered to avoid more errors, temp
		get_tree().call_deferred("reload_current_scene")

func _on_timer_timeout() -> void:
#	get_tree().reload_current_scene()
	pass
