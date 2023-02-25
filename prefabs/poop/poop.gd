extends Area2D

signal on_poop_destroyed

export(float, 0, 100) var annoyance := 5.0

onready var animation_player := $AnimationPlayer
onready var tweener = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(false) 

var is_dying := false

func _ready():
	animation_player.play("ROTATE")

func attack(
	target_position: Vector2, 
	hanging_length: float, 
	duration: float
):
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
	tweener.tween_property(self, "global_position:x", target_position.x, duration)  \
		.set_trans(Tween.TRANS_LINEAR)
	tweener.parallel() \
		.tween_property(self, "global_position:y", target_position.y, duration) \
		.set_trans(Tween.TRANS_BACK)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed: die()

func _on_Spider_area_entered(area):
	if area.name == "Coots": 
		area.decrease_patience(annoyance)
		die(true)

func die(ascend = false):
	if is_dying: return
	is_dying = true
	tweener.stop()
	set_deferred("monitoring", false)
	animation_player.play("DEAD" if not ascend else "ASCEND")
	if not ascend: 
		$CPUParticles2D.restart()
		emit_signal("on_poop_destroyed")
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
