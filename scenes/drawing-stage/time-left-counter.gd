extends Label


onready var drawing_timer := $DrawingTimer

func _physics_process(_delta):
	if not drawing_timer.is_stopped() or not drawing_timer.paused:
		text = "{0} s".format([str(int(drawing_timer.time_left))])
