extends Area2D

signal on_stroke(point)

var is_grabbing := false
var can_grab := false


func _on_Pen_mouse_entered(): can_grab = true
func _on_Pen_mouse_exited(): can_grab = false

func _unhandled_input(event): 
	if event is InputEventMouseButton:
		is_grabbing = event.pressed and can_grab

func _process(_delta):
	var global_mouse_position = get_global_mouse_position()
	if is_grabbing and (global_position - global_mouse_position).length_squared() > 0.01:
		global_position = global_mouse_position
		emit_signal("on_stroke", global_mouse_position)



