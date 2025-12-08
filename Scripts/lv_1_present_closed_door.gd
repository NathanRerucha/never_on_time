extends StaticBody2D
@onready var interaction_area: interaction_area = $InteractionArea
@onready var closed = $Lv1PresentDoorClosedSprite
@onready var open = $Lvl1PresentDoorOpenSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interact():
	if Globals.key_taken == true:
		collision_layer = 0
		closed.visible = false
		open.visible = true
		
