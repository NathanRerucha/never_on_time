extends CharacterBody2D

@export var move_speed : float = 175
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 700
@export var jump_force : float = 230

var conveyor_velocity: float = 0.0
# is this variable still used? ^ line 63 -Nathan
var base_speed: float
var move_input : float
var on_ladder: bool
var is_climbing: bool
var shift_dist : int
var current_time : int = 0
var spawn_point : Vector2 
var velocity_saved : Vector2
var is_shifting : bool = false
var can_shift : bool = false

# Moved timer variables with rest for consistency
var freeze_timer = Timer.new()
var freeze_duration = 1 # seconds

@onready var sprite : Sprite2D = $PlayerSprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var coyote_timer = $CoyoteTimer

func _ready():
	base_speed = move_speed
	#animation tween
	# Setting up timer for pausing between shifts
	add_child(freeze_timer)
	freeze_timer.connect("timeout", Callable(self, "_unfreeze_game"))
	freeze_timer.one_shot = true # The timer will only run once
	freeze_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	anim.process_mode = Node.PROCESS_MODE_ALWAYS
	
func apply_speed_modifier(modifier: float):
	move_speed = base_speed * modifier
	
func remove_speed_modifier():
	move_speed = base_speed
	
func _on_body_entered(body):
	print("body entered")
	if body.get_name() == "Ladders":
		on_ladder = true
	
func _on_body_exited(body):
	if body.get_name() == "Ladders":
		on_ladder = false

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor() && !on_ladder:
		velocity.y += gravity * delta
	
	# get the move input
	move_input = Input.get_axis("move_left", "move_right")
	
	var target_velocity_x = (move_input * move_speed) + conveyor_velocity # <-- is this variable still used? -Nathan
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, target_velocity_x, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, target_velocity_x, braking * delta)

	#jumping
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped() || on_ladder):
		velocity.y = -jump_force
		
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor && !is_on_floor():
		print("coyote timer start")
		coyote_timer.start()
	
	#ladder movement (this part is fine)
	if on_ladder:
		print("is on ladder")
		var move_input_ladder = Input.get_axis('climb_ladder', 'climb_ladder_down')
		if move_input_ladder != 0:
			velocity.y = lerp(velocity.y, move_input_ladder * move_speed, acceleration * delta)
		else:
			velocity.y = lerp(velocity.y, 0.0, braking * delta)
	
	_time_shift()
	
@warning_ignore("unused_parameter")
func _process(_delta: float) -> void:
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

func freeze_game():
	get_tree().paused = true
	freeze_timer.start(freeze_duration)

func _unfreeze_game():
	is_shifting = false
	get_tree().paused = false
	print("Game unpaused")

func _on_cutscene_trigger_1_body_entered(body) -> void:
	if body.get_class() == "CharacterBody2D":
		print("can shift")
		can_shift = true
	
func _time_shift():	
	# current time: 0 = present, 1 = future, -1 = past
	if Input.is_action_just_pressed("time_forward") and current_time == 0 and can_shift:
		print("test")
		is_shifting = true
		anim.play("time_shift2")
		# shift player vertically a set amount of pixels, sourced from level 
		freeze_game()
		position.y -= shift_dist
		# determines what time period player is in and sets the current_time variable accordingly
		current_time = 1
		
	elif Input.is_action_just_pressed("time_forward") and current_time == 1 and can_shift:
		is_shifting = true
		anim.play("time_shift2")
		freeze_game()
		position.y += shift_dist
		current_time = 0
			
func _on_animation_finished(anim_name):
	if anim_name == "time_shift2":
		is_shifting = false 
		_manage_animation()
		
func _on_timer_timeout() -> void:
	print("timeeout")
	velocity = velocity_saved

#func _death():
	# will become more complex in future (ie. animaitons and such)
	#position = spawn_points
