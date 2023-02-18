extends Reference
class_name CootsShapeGenerator


var noise : OpenSimplexNoise

func _init():
	noise = OpenSimplexNoise.new()
	
	# Configure
	noise.seed = randi()


func generate_ellipse(center: Vector2, segments: int, a: float, b: float) -> PoolVector2Array:
	var points : PoolVector2Array = []
	var difference := 2 * a / segments
	for x in range(-a, a + difference, difference): # inclusive for the end.
		var y = sqrt(abs(b*b * (1 - (x*x)/(a*a))))
		if y < 0.001:
			# y is near 0. There is no 2 values.
			points.append(Vector2(x, y) + center)
		else:
			points.push_back(Vector2(x, -y) + center) # upper point
			points.insert(0, Vector2(x, y) + center) # lower point
	points.push_back(points[0])
	return points

func generate_coots_shape(center: Vector2, size: float, fatness: float, complexity: float) -> PoolVector2Array:
	var coots : PoolVector2Array = [] 
	# apply noise
	for point in generate_ellipse(center, 50, size * fatness, size):
		coots.append(point + Vector2.DOWN * noise.get_noise_2dv(point) * complexity)
	return coots

