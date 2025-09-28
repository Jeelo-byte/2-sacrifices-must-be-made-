extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count: int = 4
@export var enemy_speed: int = 200
@export var spawn_area: Rect2 = Rect2(-512, -384, 1024, 768)

var current_wave: int = 1
var base_damage: int = 1
var enemies_dead: int = 0

func _ready():
	spawn_enemies()
	var screen = get_node("UI/GameOverScreen")
	screen.visible = false
	initialize_game_over_screen(screen)

	get_node("UI/GameOverScreen/RestartButton").pressed.connect(_on_restart_button_pressed)
	get_node("UI/GameOverScreen/MainMenuButton").pressed.connect(_on_main_menu_button_pressed)

func _process(delta):
	check_wave_complete()
	check_player_dead()

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
		e.connect("enemy_killed", Callable(self, "enemy_killed"))
		add_child(e)

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

func enemy_killed():
	enemies_dead += 1

func check_player_dead():
	var player = get_node("Player")
	if player.current_health <= 0:
		show_game_over()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func initialize_game_over_screen(screen: Control):
	for child_name in ["Background", "GameOverLabel", "StatsLabel", "RestartButton", "MainMenuButton"]:
		if screen.has_node(child_name):
			screen.get_node(child_name).modulate.a = 0.0

func show_game_over():
	var screen = get_node("UI/GameOverScreen")
	screen.visible = true
	initialize_game_over_screen(screen)
	await fade_in_game_over(screen)

func fade_in_game_over(screen: Control) -> void:
	var tween = create_tween().set_parallel()
	if screen.has_node("Background"):
		tween.tween_property(screen.get_node("Background"), "modulate:a", 1.0, 0.4).set_delay(0.0)
	if screen.has_node("GameOverLabel"):
		tween.tween_property(screen.get_node("GameOverLabel"), "modulate:a", 1.0, 0.4).set_delay(0.2)
	if screen.has_node("StatsLabel"):
		tween.tween_property(screen.get_node("StatsLabel"), "modulate:a", 1.0, 0.4).set_delay(0.4)
	if screen.has_node("RestartButton"):
		tween.tween_property(screen.get_node("RestartButton"), "modulate:a", 1.0, 0.4).set_delay(0.6)
	if screen.has_node("MainMenuButton"):
		tween.tween_property(screen.get_node("MainMenuButton"), "modulate:a", 1.0, 0.4).set_delay(0.8)
	await tween.finished
