extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count: int = 99
@export var spawn_distance_min: float = 200
@export var spawn_distance_max: float = 500

func _ready():
	spawn_enemies()

func spawn_enemies():
	var player = $Player
	
	for i in range(enemy_count):
		var e = enemy_scene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(spawn_distance_min, spawn_distance_max)
		
		var spawn_pos = player.position + Vector2(cos(angle), sin(angle)) * distance
		
		e.position = spawn_pos
		add_child(e)
