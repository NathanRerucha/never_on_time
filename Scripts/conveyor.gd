extends Area2D
class_name ConveyorArea2d

# Set this in the Inspector. 
# Use a negative value like -100 to slow the player.
@export var horizontal_speed: float = -100.0 

var objects_array: Array[Node2D] = []
var objects_speed: Array[float] = [] 

func _ready() -> void:
	set_physics_process(false)
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)
	
func _physics_process(_delta: float) -> void:
	for i in objects_array.size():
		# Check if the player is on the floor
		if objects_array[i] is CharacterBody2D and objects_array[i].is_on_floor():
			# Only apply speed if it's not already set
			if objects_speed[i] != horizontal_speed:
				
				# --- FIX 1: Use = (set) instead of += (add) ---
				objects_array[i].conveyor_velocity = horizontal_speed
				
				objects_speed[i] = horizontal_speed
		
		# If the object is in the air (but still in the area)
		elif objects_array[i] is CharacterBody2D and !objects_array[i].is_on_floor():
			# Reset its conveyor speed
			if objects_speed[i] != 0.0:
				
				# --- FIX 2: Set velocity to 0.0 ---
				objects_array[i].conveyor_velocity = 0.0
				
				objects_speed[i] = 0.0

func _object_entered(object: Node2D) -> void:
	print("Conveyor detected:", object.name)
	
	if "conveyor_velocity" in object:
		objects_array.append(object)
		objects_speed.append(0.0)
		
	if !objects_array.is_empty():
		set_physics_process(true)
	
func _object_exited(object: Node2D) -> void:
	if "conveyor_velocity" in object and objects_array.has(object):
		var object_pos: int = objects_array.find(object)
		
		# If the object was being moved, reset its conveyor velocity
		if objects_speed[object_pos] != 0.0:
			
			# --- FIX 3: Set velocity to 0.0 instead of subtracting ---
			objects_array[object_pos].conveyor_velocity = 0.0
			
		objects_array.remove_at(object_pos)
		objects_speed.remove_at(object_pos)
		
	if objects_array.is_empty():
		set_physics_process(false)
