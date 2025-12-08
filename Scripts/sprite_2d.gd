extends Sprite2D

signal door_opened

var key_taken = false
@onready var interaction_area: interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
func _on_interact():
	key_taken = true
	queue_free()
