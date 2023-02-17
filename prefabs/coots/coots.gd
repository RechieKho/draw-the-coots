extends Node2D


signal on_anger_changed(new_anger_percentage)

export(float, 100, 1000) var size := 100.0
export(float, 1, 2) var fatness := 1.5
export(float, 1, 100) var complexity := 80
export(float, 100, 1000) var max_anger := 100
export(float, 1, 100) var anger_rate := 10

onready var shape_gen := CootsShapeGenerator.new()
onready var collision_polygon := $Detector/CollisionPolygon2D

var is_angry := false
var anger := 0.0 setget set_anger
var shape : PoolVector2Array = []


func _on_Detector_area_entered(area):
	if area.name == "PenTip": is_angry = true

func _on_Detector_area_exited(area):
	if area.name == "PenTip": is_angry = false


func set_anger(value : float):
	anger = clamp(value, 0, max_anger)
	emit_signal("on_anger_changed", anger / max_anger)

func update_shape():
	shape = shape_gen.generate_coots_shape(Vector2.ZERO, size, fatness, complexity)
	collision_polygon.polygon = shape
	update()

func _process(delta):
	if is_angry:
		set_anger(anger + anger_rate * delta)

func _draw():
	if len(shape) < 3: return
	draw_colored_polygon(shape, Color.white)

