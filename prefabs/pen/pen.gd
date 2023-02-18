extends Area2D

signal on_stroke(point)

onready var pen_tip := $PenTip
onready var animation_player := $AnimationPlayer
onready var particles := $Particles

var is_grabbing := false
var can_grab := false


func _on_Pen_mouse_entered(): 
	can_grab = true
	animation_player.play("ACTIVE")

func _on_Pen_mouse_exited(): 
	can_grab = false
	animation_player.play_backwards("ACTIVE")

func set_is_grabbing(value: bool):
	is_grabbing = value
	pen_tip.monitorable = value
	if value: 
		animation_player.play("DRAW")
		particles.emitting = true
	else: animation_player.play_backwards("DRAW")

func _unhandled_input(event): 
	if event is InputEventMouseButton:
		if can_grab:
			set_is_grabbing(event.pressed)

func _process(_delta):
	var global_mouse_position = get_global_mouse_position()
	if is_grabbing and (global_position - global_mouse_position).length_squared() > 0.01:
		global_position = global_mouse_position
		emit_signal("on_stroke", global_mouse_position)



