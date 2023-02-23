extends Control



func _ready():
	BGM.current_music = null

func _on_RedrawButton_button_up():
	GFX.change_scene("res://scenes/drawing-stage/drawing-stage.tscn")


func _on_MainMenu_button_up():
	GFX.change_scene("res://scenes/main-menu/main-menu.tscn")
