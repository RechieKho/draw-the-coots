extends ProgressBar


func reduce_health(amount):
	value -= amount
	if value == 0:
		pass # Deal with death
