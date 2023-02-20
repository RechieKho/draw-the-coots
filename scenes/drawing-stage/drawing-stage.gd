extends Node2D


export(Color) var pen_color := Color.black

onready var coots := $Coots
onready var pen := $Pen
onready var pen_detector := $PenDetectors
onready var drawing_counter := $UI/DrawingCounter

var drawing_results = []
var points : PoolVector2Array = []

func _ready():
	setup_drawing()

func _draw():
	if len(points) > 2:
		draw_polyline(points, pen_color, 10)

func _on_AwayDetector_area_exited(area):
	if area.name == "Pen": 
		pen_detector.away_detector.set_deferred("monitoring", false)
		pen_detector.return_detector.set_deferred("monitoring", true)

func _on_ReturnDetector_area_entered(area):
	if area.name == "Pen":
		pen_detector.return_detector.set_deferred("monitoring", false)
		finish_drawing()

func _on_Timer_timeout():
	print("It is over.")

func setup_drawing_deferred(): call_deferred("setup_drawing")

func setup_drawing():
	coots.update_shape()
	pen.global_position = coots.shape[0] + coots.global_position
	pen_detector.global_position = pen.global_position
	pen_detector.away_detector.monitoring = true

func finish_drawing():
	var drawing_area = Math.calculate_area(points)
	var coots_area = coots.get_area()
	var result = 1 - (abs(drawing_area - coots_area) / coots_area)
	print(result)
	drawing_results.append(result)
	drawing_counter.text = str(len(drawing_results))
	points.resize(0)
	setup_drawing_deferred()

func add_stroke_point(point):
	points.append(point)
	update()

