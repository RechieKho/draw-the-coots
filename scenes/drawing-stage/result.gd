extends ColorRect


export(float, 0, 2) var tween_duration := 0.5

onready var dim_color := color
onready var panel := $Panel as Panel
onready var panel_original_rect_position := panel.rect_position
onready var drawing_count_section := $Panel/Content/DrawingCount
onready var drawing_count_value_label := $Panel/Content/DrawingCount/Value
onready var average_score_section := $Panel/Content/AverageScore
onready var average_score_value_label := $Panel/Content/AverageScore/Value
onready var health_remaining_section := $Panel/Content/HealthRemaining
onready var health_remaining_value_label := $Panel/Content/HealthRemaining/Value
onready var coots_patience_section := $Panel/Content/CootsPatience
onready var coots_patience_value_label := $Panel/Content/CootsPatience/Value
onready var grade_section := $Panel/Content/Grade
onready var grade_value_label := $Panel/Content/Grade/Value
onready var button_section := $Panel/Buttons

func _ready():
	visible = true # I might turn off in the editor
	color = Color.transparent
	panel.rect_position = Vector2(panel.rect_position.x, -1000)
	drawing_count_section.modulate = Color.transparent
	average_score_section.modulate = Color.transparent
	health_remaining_section.modulate = Color.transparent
	coots_patience_section.modulate = Color.transparent
	grade_section.modulate = Color.transparent
	button_section.modulate = Color.transparent

func show_result(
	drawing_count,
	average_score,
	health_remaining,
	coots_patience
):
	var tweener := create_tween() \
		.set_parallel(false) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	
	_show_panel(tweener)
	_show_drawing_count(tweener, drawing_count)
	_show_average_score(tweener, average_score)
	_show_health_remaining(tweener, health_remaining)
	_show_coots_patience(tweener, coots_patience)
	# Decide grade
#	_show_grade(tweener, )
	_show_button(tweener)

func _show_panel(tweener: SceneTreeTween):
	tweener.tween_property(self, "color", dim_color, tween_duration)
	tweener.parallel().tween_property(panel, "rect_position", panel_original_rect_position, tween_duration)

func _show_drawing_count(tweener: SceneTreeTween, drawing_count):
	tweener.tween_property(drawing_count_section, "modulate", Color.white, tween_duration)
	drawing_count_value_label.text = "{0} drawings".format([str(drawing_count)])

func _show_average_score(tweener: SceneTreeTween, average_score):
	tweener.tween_property(average_score_section, "modulate", Color.white, tween_duration)
	average_score_value_label.text = "{0}%".format([str(int(average_score))])

func _show_health_remaining(tweener: SceneTreeTween, health_remaining):
	tweener.tween_property(health_remaining_section, "modulate", Color.white, tween_duration)
	health_remaining_value_label.text = "{0}%".format([str(int(health_remaining))])

func _show_coots_patience(tweener: SceneTreeTween, coots_patience):
	tweener.tween_property(coots_patience_section, "modulate", Color.white, tween_duration)
	coots_patience_value_label.text = "{0}%".format([str(int(coots_patience))])

func _show_grade(tweener: SceneTreeTween, grade):
	tweener.tween_property(grade_section, "modulate", Color.white, tween_duration)
	grade_value_label.text = str(grade)

func _show_button(tweener: SceneTreeTween):
	tweener.tween_property(button_section, "modulate", Color.white, tween_duration)


func _on_RedrawButton_button_up():
	GFX.change_scene("res://scenes/drawing-stage/drawing-stage.tscn")
