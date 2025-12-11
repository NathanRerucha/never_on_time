extends StaticBody2D
#@onready var interaction_area: interaction_area = $InteractionArea
@onready var closed = $Lv1PresentDoorClosedSprite
@onready var open = $Lvl1PresentDoorOpenSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.door_open == true:
		collision_layer = 0
		closed.visible = false
		open.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.door_open == true:
		collision_layer = 0
		closed.visible = false
		open.visible = true

func on_interact():
	if Globals.key_taken == true:
		collision_layer = 0
		closed.visible = false
		open.visible = true
		
