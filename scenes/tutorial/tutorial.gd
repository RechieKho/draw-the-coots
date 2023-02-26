extends TextureRect

onready var tweener = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(false)

func _ready():
	$Text.percent_visible = 0
	$Button.modulate = Color.transparent
	
	tweener.tween_property($Text, "percent_visible", 1.0, 15)
	tweener.tween_property($Button, "modulate", Color.white, 0.25)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed: 
			tweener.stop()
			$Text.percent_visible = 1.0
			$Button.modulate = Color.white

func _on_Button_button_up():
	$ButtonSound.play()
	GFX.change_scene("res://scenes/drawing-stage/drawing-stage.tscn")
