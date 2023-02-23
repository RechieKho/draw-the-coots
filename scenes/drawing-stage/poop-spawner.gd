extends CollisionShape2D

export(float, 0, 1000) var hanging_length := 400
export(float, 0, 1) var hanging_length_randomness := 0.2
export(float, 0, 10) var attack_duration := 5
export(float, 0, 1) var attack_duration_randomness := 0.2
export(NodePath) var target_node_path := "../Coots"
export(float, 0, 1) var spawning_chance := 0.5

onready var target_node := get_node(target_node_path) as Node2D
onready var rectangle := shape as RectangleShape2D


func spawn_spider():
	var spider_resource := preload("res://prefabs/poop/poop.tscn")
	var spider := spider_resource.instance() as Node2D
	get_tree().current_scene.add_child(spider)
	spider.global_position = Vector2(
		rand_range(global_position.x - rectangle.extents.x, global_position.x + rectangle.extents.x),
		rand_range(global_position.y - rectangle.extents.y, global_position.y + rectangle.extents.y)
	)
	spider.call_deferred("attack", target_node.position, 
		rand_range(
			hanging_length * (1 - hanging_length_randomness), 
			hanging_length * (1 + hanging_length_randomness)
		),
		rand_range(
			attack_duration * (1 - attack_duration_randomness), 
			attack_duration * (1 + attack_duration_randomness)
		)
	)

func might_spawn_spider():
	var random_value := randf()
	if random_value < spawning_chance: spawn_spider()
