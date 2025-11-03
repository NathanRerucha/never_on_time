extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200

var move_input : float
var on_ladder: bool
var is_climbing: bool
var shift_dist : int
var current_time : int = 0
var spawn_point : Vector2 
var velocity_saved : Vector2
var is_shifting : bool = false

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var coyote_timer = $CoyoteTimer

func _ready():
	#animation tween
	# Setting up timer for pausing between shifts
	add_child(freeze_timer)
	freeze_timer.connect("timeout", Callable(self, "_unfreeze_game"))
	freeze_timer.one_shot = true # The timer will only run once
	freeze_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	anim.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _on_body_entered(_body: Node2D):
	on_ladder = true
	
func _on_body_exited(_body: Node2D):
	on_ladder = false

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor() && !on_ladder:
		velocity.y += gravity * delta
	
	# get the move input
	move_input = Input.get_axis("move_left", "move_right")
	
	# movement
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	#jumping
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped() || on_ladder):
		velocity.y = -jump_force
		
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
	#ladder movement
	if on_ladder:
		var move_input_ladder = Input.get_axis('climb_ladder', 'climb_ladder_down')
		if move_input_ladder != 0:
			velocity.y = lerp(velocity.y, move_input_ladder * move_speed, acceleration * delta)
		else:
			velocity.y = lerp(velocity.y, 0.0, braking * delta)
		if Input.is_action_just_pressed('jump'):
			on_ladder = false
	
	_time_shift()
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	
	_manage_animation()
	if is_shifting:
		return
	
func _manage_animation():
	#var tween = create_tween()
	#tween.tween_property($Sprite, "scale", Vector2(2,2), 1)
	if is_shifting:
		return
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play("move")
	else:
		anim.play("idle")

var freeze_duration = 1 # seconds
var freeze_timer = Timer.new()

func freeze_game():
	get_tree().paused = true
	freeze_timer.start(freeze_duration)

func _unfreeze_game():
	is_shifting = false
	get_tree().paused = false
	print("Game unpaused")
	
func _time_shift():	
	# current time: 0 = present, 1 = future, -1 = past
	if Input.is_action_just_pressed("time_forward") and current_time == 0:
		print("test")
		is_shifting = true
		anim.play("time_shift2")
		# shift player vertically a set amount of pixels, sourced from level 
		freeze_game()
		position.y -= shift_dist
		# determines what time period player is in and sets the current_time variable accordingly
		current_time = 1
		
	elif Input.is_action_just_pressed("time_forward") and current_time == 1:
		is_shifting = true
		anim.play("time_shift2")
		freeze_game()
		position.y += shift_dist
		current_time = 0
		#if current_time == 0:
			#current_time = 1
		#else:
			#current_time = 1
	#if Input.is_action_just_pressed("time_reverse") and (current_time == 0 or current_time == 1):
		#is_shifting = true
		#anim.play("time_shift")
		#freeze_game()
		#position.y += shift_dist
		#is_shifting = false
		
		#if current_time == 1:
			#current_time = 0
		#else:
			#current_time = -1
			
func _on_animation_finished(anim_name):
	if anim_name == "time_shift2":
		is_shifting = false 
		_manage_animation()
		
func _on_timer_timeout() -> void:
	print("timeeout")
	velocity = velocity_saved

func _death():
	# will become more complex in future (ie. animaitons and such)
	position = spawn_point
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
