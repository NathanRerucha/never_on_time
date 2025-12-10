extends Path2D

@export var loop = true
@export var speed = 4.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var Globals = $"/root/Globals"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress += 0
	if Globals.go_down == true:
		path.progress += speed
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)
		if !animation.is_playing():
			Globals.go_down = false
	
	if Globals.go_up == true:
		path.progress += speed
		animation.play("move back")
		animation.speed_scale = speed_scale
		set_process(false)
		if !animation.is_playing():
			Globals.go_up = false
