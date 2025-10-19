
extends StaticBody2D 

# Set this in the Inspector for each platform that will only be in the past
@export var exists_in: TimeManager.TimePeriod = TimeManager.TimePeriod.PAST

func _ready():
	# In the beginning, connect this object's "_on_time_changed" function
	# to the TimeManager's "time_period_changed" signal.
	# Now, whenever the signal is emitted, the function will run.
	TimeManager.time_period_changed.connect(_on_time_changed)
	
	
	_on_time_changed(TimeManager.current_time)

func _on_time_changed(new_time_period):
	# Check if the new time period is the one this platform exists in.
	if new_time_period == exists_in:
		visible = true
		$CollisionShape2D.disabled = false # Assuming it has a collision shape child
	else:
		visible = false
		$CollisionShape2D.disabled = true
