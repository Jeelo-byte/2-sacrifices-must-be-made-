extends Node2D
@export var enemy_scene: PackedScene
@export var enemy_count: int = 50
@export var spawn_area: Rect2 = Rect2(-512, -384, 1024, 768)

func _ready():
	spawn_enemies()

func spawn_enemies():
	for i in range(enemy_count):
		var e = enemy_scene.instantiate()
		var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		e.position = Vector2(x, y)
		add_child(e)
