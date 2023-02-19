extends ColorRect


signal on_start_biting()
signal on_relieving(amount) # increase patience of coots
signal on_hurting(amount) # reduce health of player

export(float, 0, 2) var tween_duration := 0.75
export(float, 0, 100) var health_reduce_rate := 5.0
export(float, 0, 10) var patience_increase_rate := 5 
export(float, 0, 10) var patience_click_increase_rate := 4
export(float, 0, 10) var biting_time_click_reduce_rate := 2
export(float, 0, 50) var max_biting_time := 10

onready var biting_timer := $BitingTimer
onready var contents := $Contents
onready var dim_color := modulate

func _ready():
	visible = true # I might turn off visible in editor.
	modulate = Color.transparent
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	if biting_timer.is_stopped(): return
	if event is InputEventMouseButton:
		if event.doubleclick:
			emit_signal("on_relieving", patience_click_increase_rate)
			var new_biting_time = \
				clamp(biting_timer.time_left - biting_time_click_reduce_rate, 0, max_biting_time)
			if new_biting_time == 0: 
				biting_timer.stop()
				biting_timer.emit_signal("timeout") # it doesn't emit timeout if stop manually
			else: biting_timer.start(new_biting_time)

func _process(delta):
	if biting_timer.is_stopped(): return
	emit_signal("on_relieving", patience_increase_rate * delta)
	emit_signal("on_hurting", health_reduce_rate * delta)

func set_biting(value: bool) :
	var tweener := create_tween() \
		.set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	if value:
		emit_signal("on_start_biting")
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		tweener.tween_property(self, "modulate", dim_color, tween_duration)
		tweener.tween_property(contents, "rect_position", Vector2.ZERO, tween_duration)
		biting_timer.start(max_biting_time)
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		tweener.tween_property(self, "modulate", Color.transparent, tween_duration)
		tweener.tween_property(contents, "rect_position", Vector2(0, -1000), tween_duration)
