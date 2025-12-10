extends Path2D

@export var loop = true
@export var speed = 4.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var sprite = $AnimatableBody2D/Sprite2D
@onready var Globals = $"/root/Globals"

var tex_off = load("res://Sprites/Elevator/LV1Past_Elevator_Light_Off-sprite (1).png")
var tex_on = load("res://Sprites/Elevator/LV1Past_Elevator_Light_On-sprite (1).png")

func _ready() -> void:
	sprite.texture = tex_off

func _process(_delta: float) -> void:
	if Globals.power_on == true:
		sprite.texture = tex_on
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
