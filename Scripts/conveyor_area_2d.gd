extends Area2D
class_name ConveyorArea2d

@export var horizontal_speed: float = 0.5
var objects_array: Array[Node2D] = []
var objects_speed: Array[float] = []

func _ready() -> void:
	set_physics_process(false)
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)
	
func _physics_process(delta: float) -> void:
	for i in objects_array.size():
		if objects_array[i].is_on_floor() and objects_speed[i] != horizontal_speed:
			objects_array[i].conveyor_velocity += horizontal_speed
			objects_speed[i] = horizontal_speed
		elif !objects_array[i].is_on_floor() and objects_speed[i] != 0.0:
			objects_array[i].conveyor_velocity -= horizontal_speed
			objects_speed[i] = 0.0

func _object_entered(object: Node2D) -> void:
	if "conveyor_velocity" in object:
		objects_array.append(object)
		objects_speed.append(0.0)
		
	if !objects_array.is_empty():
		set_physics_process(true)
	
func _object_exited(object: Node2D) -> void:
	if "conveyor_velocity" in object and objects_array.has(object):
		var object_pos: int = objects_array.find(object)
		if objects_speed[object_pos] != 0.0:
			objects_array[object_pos].conveyor_velocity -= horizontal_speed
		objects_array.remove_at(object_pos)
		objects_speed.remove_at(object_pos)
		
	if objects_array.is_empty():
		set_physics_process(false)
