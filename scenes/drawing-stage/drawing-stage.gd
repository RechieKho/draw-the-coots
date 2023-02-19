extends Node2D


export(Color) var pen_color := Color.black

onready var coots := $Coots
onready var pen := $Pen

var points : PoolVector2Array = []

func _ready():
	setup_drawing()

func setup_drawing():
	coots.update_shape()
	pen.global_position = coots.shape[0] + coots.global_position

func _draw():
	if len(points) > 2:
		draw_polyline(points, pen_color, 10)

func add_stroke_point(point):
	points.append(point)
	update()

func calculate_area(points: PoolVector2Array):
	var area = 0
	for i in len(points) - 1:
		area += (points[i].x * points[i + 1].y - points[i].y * points[i + 1].x)
	area = abs(area) / 2
	return area
