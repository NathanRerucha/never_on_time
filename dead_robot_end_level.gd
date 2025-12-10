extends Area2D 

@export var target_level: PackedScene 

func _on_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body.name)
	if body.is_in_group("Player"):
		change_level()
		

func change_level() -> void:
	if target_level == null:
		print("Error: No target level scene selected!")
		return
		
	call_deferred("_deferred_change_scene")

func _deferred_change_scene() -> void:
	get_tree().change_scene_to_packed(target_level)
