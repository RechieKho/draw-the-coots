extends ProgressBar


func update_patience_meter(new_patience_percentage):
	value = new_patience_percentage * max_value
