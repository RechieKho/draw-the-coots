extends Area2D

signal on_stroke(point)

export(NodePath) var paper_region_path := ""

onready var pen_tip := $PenTip
onready var animation_player := $AnimationPlayer
onready var particles := $Particles
onready var paper_region = get_node_or_null(paper_region_path)

var is_grabbing := false
var can_grab := false


func _on_Pen_mouse_entered(): 
	can_grab = true
	animation_player.play("ACTIVE")

func _on_Pen_mouse_exited(): 
	can_grab = false
	if not is_grabbing: animation_player.play_backwards("ACTIVE")

func set_is_grabbing(value: bool):
	if is_grabbing == value: return
	is_grabbing = value
	pen_tip.monitorable = value
	if value: 
		animation_player.play("DRAW")
		particles.emitting = true
	elif can_grab: animation_player.play_backwards("DRAW")
	else: animation_player.play_backwards("ACTIVE")

#func _unhandled_input(event): 
#	if event is InputEventMouseButton:
#		if can_grab:
#			set_is_grabbing(event.pressed)

func _process(_delta):
	# inputs
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if can_grab: set_is_grabbing(true)
	else: set_is_grabbing(false)
	
	# position
	var global_mouse_position = get_global_mouse_position()
	if is_grabbing and (global_position - global_mouse_position).length_squared() > 0.01:
		var clamped_position = null
		if paper_region is Control: 
			clamped_position = Vector2(
				clamp(
					global_mouse_position.x, 
					paper_region.rect_position.x,
					paper_region.rect_position.x + paper_region.rect_size.x
				),
				clamp(
					global_mouse_position.y, 
					paper_region.rect_position.y,
					paper_region.rect_position.y + paper_region.rect_size.y
				)
			)
		else: clamped_position = global_mouse_position
		global_position = clamped_position
		emit_signal("on_stroke", clamped_position)



