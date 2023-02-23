extends ProgressBar


func reduce_health(amount):
	value -= amount
	if value == 0:
		GFX.change_scene("res://scenes/dead/dead.tscn")
