extends Area2D

func _on_body_entered(body) -> void:
	if body.get_class() == "CharacterBody2D":
		$AudioStreamPlayer2D.play()
