extends Area2D
class_name interaction_area

@export var action_name: String = "F: interact"

var interact: Callable = func():
	pass

func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)

func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
