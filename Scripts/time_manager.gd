enum TimePeriod {PAST, PRESENT, FUTURE}

extends Node

var current_time: TimePeriod = TimePeriod.PRESENT

signal time_period_changed(new_time_period)

func shift_time():
	match current_time:
		TimePeriod.PRESENT:
			current_time = TimePeriod.FUTURE
		TimePeriod.FUTURE:
			current_time = TimePeriod.PAST
		TimePeriod.PAST:
			current_time = TimePeriod.PRESENT
	
	emit_signal("time_period_changed", current_time)
	print("Time shifted to: ", TimePeriod.keys()[current_time])
