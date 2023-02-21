extends Camera2D

"""Extends the functionality of Camera2D"""

class_name SmoothCamera2D

### VARIABLE ###

export(NodePath) var default_follow_node := ""
export(float, 0, 1) var follow_weight := 0.1

onready var follow_node : Node2D = get_node_or_null(default_follow_node)

### FUNCTIONS ###
# --- Private ---

func _notification(what):
	if current:
		match what:
			NOTIFICATION_EXIT_TREE, NOTIFICATION_PATH_CHANGED:
				Camera2DUtility.erase_camera_cache(get_viewport())

func _process(_delta):
	if follow_node:
		var target_global_position := follow_node.global_position
		if (target_global_position - global_position).length_squared() > 0.1:
			global_position = lerp(global_position, target_global_position, follow_weight)
