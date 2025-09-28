extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count: int = 5
@export var spawn_area: Rect2 = Rect2(Vector2.ZERO, Vector2(1024, 768))

func _ready():
	spawn_enemies()

func spawn_enemies():
	for i in range(enemy_count):
		var e = enemy_scene.instantiate()
		var x = randi() % int(spawn_area.size.x) + spawn_area.position.x
		var y = randi() % int(spawn_area.size.y) + spawn_area.position.y
		e.position = Vector2(x, y)
		add_child(e)
