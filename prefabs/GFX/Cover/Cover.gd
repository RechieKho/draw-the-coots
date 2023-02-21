extends ColorRect

### VARIABLES ###
export var tween_duration := 0.7

onready var darkened_color = color

### FUNCTIONS ###
# --- Publics ---
func smoothly_darken():
	var tweener := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tweener.tween_property(self, "color", darkened_color, tween_duration)

func smoothly_hidden():
	var tweener := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tweener.tween_property(self, "color", Color.transparent, tween_duration)

# --- Privates ---
func _ready():
	color = Color.transparent
