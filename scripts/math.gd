extends Reference
class_name Math

static func calculate_area(points: PoolVector2Array):
	var area = 0
	for i in len(points) - 1:
		area += (points[i].x * points[i + 1].y - points[i].y * points[i + 1].x)
	area = abs(area) / 2
	return area
