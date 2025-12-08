extends Sprite2D

signal door_opened


@onready var interaction_area: interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
func on_interact():
	Globals.key_taken = true
	visible = false
