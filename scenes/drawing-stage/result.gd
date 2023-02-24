extends ColorRect


export(float, 0, 2) var tween_duration := 0.5

onready var dim_color := color
onready var panel := $Panel as Panel
onready var panel_original_rect_position := panel.rect_position
onready var money_section := $Panel/Content/Money
onready var money_value_label := $Panel/Content/Money/Value
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
	money_section.modulate = Color.transparent
	health_remaining_section.modulate = Color.transparent
	coots_patience_section.modulate = Color.transparent
	grade_section.modulate = Color.transparent
	button_section.modulate = Color.transparent

func show_result(
	money,
	health_remaining,
	coots_patience
):
	var tweener := create_tween() \
		.set_parallel(false) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	
	_show_panel(tweener)
	_show_money(tweener, money)
	_show_health_remaining(tweener, health_remaining)
	_show_coots_patience(tweener, coots_patience)
	
	var grade : String
	if money < 5: grade = "Poor... :("
	elif money < 20: grade = "Cool, you have money."
	elif money < 40: grade = "Damn, you have a lot of money"
	elif money < 70: grade = "DAMN, you are RICH!"
	elif money < 100: grade = "Super RICH!!!"
	else: grade = "You are as RICH as Mr. Krab!!!"
	
	_show_grade(tweener, grade)
	_show_button(tweener)

func _show_panel(tweener: SceneTreeTween):
	tweener.tween_property(self, "color", dim_color, tween_duration)
	tweener.parallel().tween_property(panel, "rect_position", panel_original_rect_position, tween_duration)

func _show_money(tweener: SceneTreeTween, money):
	tweener.tween_property(money_section, "modulate", Color.white, tween_duration)
	money_value_label.text = "${0}".format([str(money)])

func _show_health_remaining(tweener: SceneTreeTween, health_remaining):
	tweener.tween_property(health_remaining_section, "modulate", Color.white, tween_duration)
	health_remaining_value_label.text = "{0}%".format([str(int(health_remaining))])

func _show_coots_patience(tweener: SceneTreeTween, coots_patience):
	tweener.tween_property(coots_patience_section, "modulate", Color.white, tween_duration)
	coots_patience_value_label.text = "{0}%".format([str(int(coots_patience))])

func _show_grade(tweener: SceneTreeTween, grade: String):
	tweener.tween_property(grade_section, "modulate", Color.white, tween_duration)
	grade_value_label.text = grade

func _show_button(tweener: SceneTreeTween):
	tweener.tween_property(button_section, "modulate", Color.white, tween_duration)


func _on_RedrawButton_button_up():
	$ButtonSound.play()
	GFX.change_scene("res://scenes/drawing-stage/drawing-stage.tscn")


func _on_ExitButton_button_up():
	$ButtonSound.play()
	GFX.change_scene("res://scenes/main-menu/main-menu.tscn")
