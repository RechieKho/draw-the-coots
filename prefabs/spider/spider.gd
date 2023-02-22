extends Area2D


export(float, 0, 100) var annoyance := 5.0

func attack(
	target_position: Vector2, 
	hanging_length: float, 
	duration: float
):
	var tweener = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(false)
	hang(tweener, hanging_length, duration/2)
	hunt(tweener, target_position, duration/2) 

func hang(
	tweener :SceneTreeTween, 
	length: float, 
	duration: float
):
	var end_position := global_position + Vector2.DOWN * length
	tweener.tween_property(self, "global_position", 
		end_position, 
		duration
	)

func hunt(tweener: SceneTreeTween, target_position: Vector2, duration: float):
	monitoring = true
	tweener.tween_property(self, "global_position:x", target_position.x, duration)  \
		.set_trans(Tween.TRANS_LINEAR)
	tweener.parallel() \
		.tween_property(self, "global_position:y", target_position.y, duration) \
		.set_trans(Tween.TRANS_BACK)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed: queue_free() # TODO: Add animation.

func _on_Spider_area_entered(area):
	if area.name == "Coots": 
		area.decrease_patience(annoyance)
		queue_free() # TODO: Add animation.
