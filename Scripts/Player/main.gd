extends Node2D
@export var enemy_scene: PackedScene
@export var enemy_count: int = 4
@export var enemy_speed: int = 200
@export var spawn_area: Rect2 = Rect2(-512, -384, 1024, 768)

var current_wave: int = 1
var base_damage: int = 1

func _ready():
	spawn_enemies()

func _process(delta):
	check_wave_complete()

func check_wave_complete():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		enemy_count = ceil(1.5 * enemy_count)
		enemy_speed = ceil(1.5 * enemy_speed)
		start_next_wave()

func start_next_wave():
	current_wave += 1
	var wave_damage = base_damage * (2 ** (current_wave - 1))
	spawn_enemies_with_damage(wave_damage)

func spawn_enemies():
	spawn_enemies_with_damage(base_damage)

func spawn_enemies_with_damage(damage: int):
	for i in range(enemy_count):
		var e = enemy_scene.instantiate()
		var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		e.position = Vector2(x, y)
		e.damage_amount = damage
		e.move_speed = enemy_speed
		add_child(e)


func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
