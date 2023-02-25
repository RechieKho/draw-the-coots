extends ColorRect


export(float, 0, 2) var tween_duration := 0.5
export(NodePath) var money_manager_path := @"../../"
export(NodePath) var health_path := @"../ProgressBars/HealthBar"
export(NodePath) var coots_path := @"../../Coots"

export(int, 1, 20) var bandage_cost := 3
export(int, 1, 20) var patience_cost := 7
export(int, 1, 20) var poop_cost := 15

onready var dim_color := color
onready var panel := $Panel as Panel
onready var bandage_cost_label := $Panel/Content/Bandage/Items/Cost
onready var patience_cost_label := $Panel/Content/Patience/Items/Cost
onready var poop_cost_label := $Panel/Content/PoopMoney/Items/Cost
onready var panel_original_rect_position := panel.rect_position
onready var panel_hiding_position = Vector2(panel.rect_position.x, -1000)
onready var money_manager = get_node(money_manager_path)
onready var health = get_node(health_path)
onready var coots = get_node(coots_path)
onready var error_audio_player := $ErrorSound
onready var button_audio_player := $ButtonSound

func _ready():
	visible = true # I might turn off in the editor
	color = Color.transparent
	panel.rect_position = panel_hiding_position
	bandage_cost_label.text = "${0}".format([bandage_cost])
	patience_cost_label.text = "${0}".format([patience_cost])
	poop_cost_label.text = "${0}".format([poop_cost])

func show_shop():
	mouse_filter = MOUSE_FILTER_STOP
	get_tree().paused = true
	var tweener := create_tween() \
		.set_parallel(false) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	tweener.tween_property(self, "color", dim_color, tween_duration)
	tweener.parallel().tween_property(panel, "rect_position", panel_original_rect_position, tween_duration)

func hide_shop():
	mouse_filter = MOUSE_FILTER_IGNORE
	get_tree().paused = false
	var tweener := create_tween() \
		.set_parallel(false) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	tweener.tween_property(self, "color", Color.transparent, tween_duration)
	tweener.parallel().tween_property(panel, "rect_position", panel_hiding_position, tween_duration)
	button_audio_player.play()


func buy_bandage():
	if money_manager.use_money(bandage_cost): 
		health.increase_health(10)
		button_audio_player.play()
	else : error_audio_player.play()

func buy_patience():
	if money_manager.use_money(patience_cost): 
		coots.patience_increase_rate += 10
		button_audio_player.play()
	else : error_audio_player.play()

func buy_poop():
	if money_manager.use_money(poop_cost): 
		money_manager.poop_value += 2
		button_audio_player.play()
	else : error_audio_player.play()
