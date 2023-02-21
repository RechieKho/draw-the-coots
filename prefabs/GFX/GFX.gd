# AUTOLOAD
extends Node


const TWEEN_DURATION := 1

### VARIABLES ###

var blur_gfxes : GFXES
var circle_gfxes : GFXES
var distortion_gfxes : GFXES
var shockwaves_gfx 

var _shaker: ShakeOffset
var _is_changing_scene := false

### FUNCTIONS ###
# --- Publics ---
func shake_current_camera(
	duration := 0.1, 
	displacement_multiplier := Vector2(10, 10), 
	rotation_multiplier := 0.0
	):
		shake_current_camera_in_viewport(
			get_viewport(),
			duration,
			displacement_multiplier,
			rotation_multiplier
		)

func shake_current_camera_in_viewport(
	viewport: Node, 
	duration := 0.1,
	displacement_multiplier := Vector2(10, 10), 
	rotation_multiplier := 0.0
	):
	if not _shaker:
		# setup shaker
		_shaker = ShakeOffset.new()
		add_child(_shaker)
		_shaker.process_mode = ShakeOffset.ProcessMode.PHYSICS
	_shaker.shake_coefficient = 1
	_shaker.target = Camera2DUtility.get_current_camera_in_viewport(viewport)
	_shaker.displacement_multiplier = displacement_multiplier
	_shaker.rotation_multiplier = rotation_multiplier
	yield(get_tree().create_timer(duration), "timeout")
	_shaker.shake_coefficient = 0.5

func change_scene(resource_path: String):
	if _is_changing_scene: return
	_is_changing_scene = true
	var circle_gfx = circle_gfxes.get_gfx("change_scene")
	circle_gfx.smooth_circle_size.smoothly_change_to(0.0, TWEEN_DURATION)
	yield(get_tree().create_timer(TWEEN_DURATION), "timeout")
	get_tree().change_scene(resource_path)
	_is_changing_scene = false
	circle_gfx.smooth_circle_size.smoothly_change_to(1.0, TWEEN_DURATION)

# --- Privates ---
func _ready():
	var canvas = CanvasLayer.new()
	add_child(canvas)
	blur_gfxes = GFXES.new(canvas, preload("Blur/Blur.tscn"))
	circle_gfxes = GFXES.new(canvas, preload("Circle/Circle.tscn"))
	distortion_gfxes = GFXES.new(canvas, preload("Distortion/Distortion.tscn"))
	
	shockwaves_gfx = preload("Shockwaves/Shockwaves.tscn").instance()
	canvas.add_child(shockwaves_gfx)

### SUBCLASSES ###
class GFXES:
	var _canvas :CanvasLayer
	var _gfx_resource
	var _gfxes = {}
	
	func _init(canvas: CanvasLayer, gfx_resource):
		_canvas = canvas
		_gfx_resource = gfx_resource
	
	func create_gfx(key: String):
		if key in _gfxes.keys():
			return
		var new_gfx = _gfx_resource.instance()
		_gfxes[key] = new_gfx
		_canvas.add_child(new_gfx)
	
	func remove_gfx(key: String):
		var gfx = _gfxes.get(key)
		if gfx == null:
			return 
		_gfxes.erase(key)
		_canvas.remove_child(gfx)
		gfx.queue_free()
	
	func get_gfx(key: String):
		create_gfx(key)
		return _gfxes[key]
