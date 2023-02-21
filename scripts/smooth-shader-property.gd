extends Reference
class_name SmoothShaderProp


var transition_type: int
var ease_type: int
var shader_param: ShaderParam
var scene_tree: SceneTree

func _init(
	scene_tree: SceneTree, 
	shader: ShaderMaterial, 
	param: String, 
	default_transition_type = Tween.TRANS_QUAD,
	default_ease_type = Tween.EASE_IN_OUT
	):
	self.scene_tree = scene_tree
	shader_param = ShaderParam.new(shader, param)
	transition_type = default_transition_type
	ease_type = default_ease_type

func smoothly_change_to(new_value, duration: float):
	var tween = scene_tree.create_tween().set_trans(transition_type).set_ease(ease_type)
	tween.tween_property(shader_param, "prop", new_value, duration)
	return tween

### SUBCLASS ###
class ShaderParam:
	
	var _shader: ShaderMaterial
	var _param: String
	var prop setget set_prop, get_prop
	
	func _init(shader: ShaderMaterial, param: String):
		_shader = shader
		_param = param
	
	func set_prop(value):
		_shader.set_shader_param(_param, value)
	
	func get_prop():
		return _shader.get_shader_param(_param)
