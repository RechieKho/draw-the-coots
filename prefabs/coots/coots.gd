extends Area2D


const anger_animation_map := ["RESET", "OPEN_RIGHT_EYE", "OPEN_LEFT_EYE", "ANGRY"]

signal on_lost_control()
signal on_patience_changed(new_patience_percentage)

export(Color) var outline_color := Color.black
export(float, 1, 100) var outline_width := 10
export(float, 100, 1000) var size := 100.0
export(float, 1, 2) var fatness := 1.5
export(float, 1, 100) var complexity := 80
export(float, 1, 100) var max_patience := 100
export(float, 1, 100) var patience_reduce_rate := 10 # per seconds
export(float, 1, 100) var patience_increase_rate := 10 # per call

onready var shape_gen := CootsShapeGenerator.new()
onready var collision_polygon := $CollisionPolygon2D
onready var body_texture := preload("res://assets/graphics/coots/coots-skin-texture.png") as Texture
onready var patience : float = max_patience setget set_patience
onready var animation_player := $AnimationPlayer

var is_angry := false
var shape : PoolVector2Array = []
var anger_state := 0

func _ready():
	emit_signal("on_patience_changed", patience / max_patience)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		if is_angry: return
		if event.button_mask & BUTTON_LEFT:
			set_patience(patience + patience_increase_rate * get_process_delta_time())

func _on_Coots_area_entered(area):
	if area.name == "PenTip": is_angry = true

func _on_Coots_area_exited(area):
	if area.name == "PenTip": is_angry = false

func get_area(): return Math.calculate_area(shape)

func increase_anger():
	anger_state = clamp(anger_state + 1, 0, len(anger_animation_map))
	animation_player.play(anger_animation_map[anger_state])

func reduce_anger():
	animation_player.play_backwards(anger_animation_map[anger_state])
	anger_state = clamp(anger_state - 1, 0, len(anger_animation_map))

func increase_patience(amount: float): set_patience(patience + amount)

func decrease_patience(amount: float): set_patience(patience - amount)

func set_patience(value : float):
	patience = clamp(value, 0, max_patience)
	var patience_percentage := patience / max_patience
	
	if anger_state == 0: 
		if patience_percentage < 0.75: increase_anger()
	elif anger_state == 1:
		if patience_percentage < 0.5: increase_anger()
		elif patience_percentage >= 0.75: reduce_anger()
	elif anger_state == 2:
		if patience_percentage < 0.25: increase_anger()
		elif patience_percentage >= 0.5: reduce_anger()
	elif anger_state == 3:
		if patience_percentage >= 0.25: reduce_anger()
	
	emit_signal("on_patience_changed", patience_percentage)
	if patience == 0: emit_signal("on_lost_control")

func update_shape():
	shape = shape_gen.generate_coots_shape(Vector2.ZERO, size, fatness, complexity)
	collision_polygon.polygon = shape
	call_deferred("update")

func _process(delta):
	if is_angry:
		set_patience(patience - patience_reduce_rate * delta)

func _draw():
	if len(shape) < 3: return
	draw_colored_polygon(shape, Color.whitesmoke, [], body_texture)
	draw_polyline(shape, outline_color, outline_width, true)




