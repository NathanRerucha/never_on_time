extends CharacterBody2D

@export var move_speed : float = 120
@export var sprint_speed : float = 200
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 700
@export var jump_force : float = 230
@export var can_shift : bool = false

var conveyor_velocity: float = 0.0
var base_speed: float
var move_input : float
var on_ladder: bool
var is_climbing: bool
var shift_dist : int
var last_checkpoint : Vector2
var current_time : int = 0
var spawn_point : Vector2 
var is_shifting : bool = false

# Moved timer variables with rest for consistency
var freeze_timer = Timer.new()
var freeze_duration = 1 # seconds

@onready var sprite : Sprite2D = $PlayerSprite
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var time_anim : AnimationPlayer = $AnimationPlayer
@onready var coyote_timer = $CoyoteTimer

func _ready():
	time_anim.play("time_shift2") # had to do this to like "preload" the timeshift animation, not pretty but it works. Will probably have to change later -Nathan
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

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor() && !on_ladder:
		velocity.y += gravity * delta
	
	# get the move input
	move_input = Input.get_axis("move_left", "move_right")
	
	var target_velocity_x
	if Input.is_action_pressed("sprint"):
		target_velocity_x = (move_input * sprint_speed) + conveyor_velocity
	else:
		target_velocity_x = (move_input * move_speed) + conveyor_velocity
	
	
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
		coyote_timer.start()
	
	#ladder movement (this part is fine)
	if on_ladder:
		# checks if player is currently pressing W or S, if not, use normal gravity
		if Input.is_action_pressed("climb_ladder") or Input.is_action_pressed("climb_ladder_down"):
			is_climbing = true # if player is still on ladder, freeze gravity
			var move_input_ladder = Input.get_axis('climb_ladder', 'climb_ladder_down')
			# if either W or S are pressed, accelerate in the y axis, direction determined by 
			# move_input_ladder being negaitve or positive
			if move_input_ladder != 0: 
				velocity.y = lerp(velocity.y, move_input_ladder * move_speed, acceleration * delta)
			else:
				velocity.y = lerp(velocity.y, 0.0, braking * delta) # stops gravity and allows player to float
		else: # if not pressing W or S, use normal gravity, unless player is on the ladder, then freeze
			if is_climbing:
				velocity.y = lerp(velocity.y, 0.0, braking * delta) # freeze
			else:
				velocity.y += gravity * delta # normal
	_time_shift()

func _process(_delta: float) -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	
	_manage_animation()
	if is_shifting:
		return
	
func _manage_animation():
	
	var still_falling = false
	if !is_on_floor():
		still_falling = true
	if is_shifting:
		return
		
	if not is_on_floor() and !is_climbing and velocity.y <  0:
		if move_input > 0:
			anim.flip_h = true
		if move_input < 0:
			anim.flip_h = false
		anim.play("jump")
	elif not is_on_floor() and !is_climbing and !still_falling and velocity.y > 0:
		if move_input > 0:
			anim.flip_h = true
		if move_input < 0:
			anim.flip_h = false
		anim.play("fall")
	elif move_input > 0:
		anim.flip_h = true
		if Input.is_action_pressed("sprint"):
			anim.play("sprint")
		else:
			anim.play("walk")
	elif move_input < 0:
		anim.flip_h = false
		if Input.is_action_pressed("sprint"):
			anim.play("sprint")
		else:
			anim.play("walk")
	else:
		anim.play("idle")

func freeze_game():
	get_tree().paused = true
	freeze_timer.start(freeze_duration)

func _unfreeze_game():
	get_tree().paused = false
	is_shifting = false
	print("Game unpaused")
	
func _time_shift():	
	if Input.is_action_just_pressed("time_shift") and current_time == 0 and can_shift:
		time_anim.play("time_shift2")
		freeze_game()
		is_shifting = true
		# shift player vertically a set amount of pixels, sourced from level 
		position.y -= shift_dist
		# determines what time period player is in and sets the current_time variable accordingly
		current_time = 1
		
	elif Input.is_action_just_pressed("time_shift") and current_time == 1 and can_shift:
		time_anim.play("time_shift2")
		freeze_game()
		is_shifting = true
		position.y += shift_dist
		current_time = 0
			
func _on_animation_finished(anim_name):
	if anim_name == "time_shift2":
		is_shifting = false 
		#_manage_animation()

func death():
	global_position = last_checkpoint
	print("Player died")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass


func _on_cutscene_trigger_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_shift = true
		print("Player can now time shift")
