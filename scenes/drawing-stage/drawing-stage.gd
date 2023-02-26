extends Node2D


export(Color) var pen_color := Color.black
export(float, 0, 600) var difficulty_increment_duration := 230
export(int, 0, 10) var poop_value := 0 

onready var coots := $Coots
onready var pen := $Pen
onready var pen_detector := $PenDetectors
onready var money_counter := $UI/MoneyCounter
onready var result := $UI/Result
onready var health_bar := $UI/ProgressBars/HealthBar

var money := 0
var points : PoolVector2Array = []

func _ready():
	BGM.volume_db = 0
	BGM.current_music = preload("res://assets/audio/Morning routine.wav")
	create_tween().tween_property(
		$SpawnTimer, "wait_time", 1.0, difficulty_increment_duration
	)
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
	# Show result.
	var health_remaining = health_bar.value * 100.0 / health_bar.max_value
	var coots_patience = coots.patience * 100.0 / coots.max_patience
	
	result.show_result(
		money, health_remaining, coots_patience
	)

func setup_drawing_deferred(): call_deferred("setup_drawing")

func setup_drawing():
	coots.update_shape()
	pen.global_position = coots.shape[0] + coots.global_position
	pen_detector.global_position = pen.global_position
	pen_detector.away_detector.monitoring = true

func finish_drawing():
	var drawing_area = Math.calculate_area(points)
	var coots_area = coots.get_area() + 1000 # offset because a lot doesn't do well :(
	var result = 1 - (abs(drawing_area - coots_area) / coots_area)
	money += 1
	if result < 0.2: money += 1
	elif result < 0.4: money += 3
	elif result < 0.6: money += 7
	elif result < 1.0: money += 10
	$MoneySound.play()
	money_counter.text = "${0}".format([money])
	points.resize(0)
	setup_drawing_deferred()

func add_stroke_point(point):
	points.append(point)
	update()

func use_money(amount):
	if money < amount: return false
	money -= amount
	money_counter.text = "${0}".format([money])
	return true

func on_poop_destroyed():
	if poop_value != 0: $MoneySound.play()
	money += poop_value
	money_counter.text = "${0}".format([money])
