extends TextureRect


func _ready():
	BGM.volume_db = 0
	BGM.current_music = preload("res://assets/audio/LoadingKitty.wav")


func _on_Button_button_up():
	$ButtonSound.play()
	GFX.change_scene("res://scenes/drawing-stage/drawing-stage.tscn")
