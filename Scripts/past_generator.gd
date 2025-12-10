extends StaticBody2D

@onready var sprite = $Lv1PastGeneratorSprite
var gen_off_tex = load("res://Sprites/Objects/LV1Past_Generator-sprite.png")
var gen_on_tex = load("res://Sprites/Objects/LV1Past_Generator_Glow-sprite.png")

signal power_on

func _ready() -> void:
	sprite.texture = gen_off_tex

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Box"):
		emit_signal("power_on")
		sprite.texture = gen_on_tex
		
