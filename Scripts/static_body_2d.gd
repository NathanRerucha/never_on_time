extends StaticBody2D
@onready var interaction_area: interaction_area = $InteractionArea
@onready var open = $past_open
@onready var closed = $past_closed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	
func on_interact():
	if Globals.key_taken == true:
		Globals.door_open = true
		open.visible = true
		closed.visible = false
		collision_layer = 0
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
