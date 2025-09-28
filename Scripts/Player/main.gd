extends Node2D
@export var enemy_scene: PackedScene
@export var enemy_count: int = 4
@export var enemy_speed: int = 200
@export var spawn_area: Rect2 = Rect2(-512, -384, 1024, 768)

var current_wave: int = 1
var base_damage: int = 1
var total_enemies_spawned: int = 0
var enemies_killed: int = 0

func _ready():
	spawn_enemies()
	# Connect to enemy deaths
	get_tree().node_removed.connect(_on_node_removed)

func _on_node_removed(node):
	if node.is_in_group("enemies"):
		enemies_killed += 1

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
		total_enemies_spawned += 1

func get_enemies_killed() -> int:
	return enemies_killed

func get_total_enemies_spawned() -> int:
	return total_enemies_spawned

func show_game_over():
	var screen = $UI/GameOverScreen
	if get_tree().paused:
		get_tree().paused = false

	# Reset all children to transparent
	if screen.has_node("Background"):
		screen.get_node("Background").modulate.a = 0.0
	if screen.has_node("GameOverLabel"):
		screen.get_node("GameOverLabel").modulate.a = 0.0
	if screen.has_node("RestartButton"):
		screen.get_node("RestartButton").modulate.a = 0.0
	if screen.has_node("MainMenuButton"):
		screen.get_node("MainMenuButton").modulate.a = 0.0
	if screen.has_node("StatsLabel"):
		screen.get_node("StatsLabel").modulate.a = 0.0

	screen.visible = true
	await get_tree().create_timer(0.02).timeout

	# Parallel tween: each property animates independently
	var tween = create_tween().set_parallel()

	if screen.has_node("Background"):
		tween.tween_property(screen.get_node("Background"), "modulate:a", 1.0, 0.4)
	if screen.has_node("GameOverLabel"):
		tween.tween_property(screen.get_node("GameOverLabel"), "modulate:a", 1.0, 0.4).set_delay(0.2)
	if screen.has_node("RestartButton"):
		tween.tween_property(screen.get_node("RestartButton"), "modulate:a", 1.0, 0.4).set_delay(0.4)
	if screen.has_node("MainMenuButton"):
		tween.tween_property(screen.get_node("MainMenuButton"), "modulate:a", 1.0, 0.4).set_delay(0.6)
	if screen.has_node("StatsLabel"):
		tween.tween_property(screen.get_node("StatsLabel"), "modulate:a", 1.0, 0.4).set_delay(0.8)
