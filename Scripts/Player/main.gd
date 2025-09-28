extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count: int = 4
@export var enemy_speed: int = 200
@export var spawn_area: Rect2 = Rect2(-512, -384, 1024, 768)

var current_wave: int = 1
var base_damage: int = 1
var enemies_dead: int = 0
var game_over_shown: bool = false

func _ready():
	spawn_enemies()
	var screen = $Player/PlayerAnim/PlayerCam/UI/GameOverScreen
	screen.visible = true
	for child_name in ["Background", "GameOverLabel", "StatsLabel", "RestartButton", "MainMenuButton"]:
		if screen.has_node(child_name):
			screen.get_node(child_name).modulate.a = 0.0
	$Player/PlayerAnim/PlayerCam/UI/GameOverScreen/RestartButton.pressed.connect(_on_restart_button_pressed)
	$Player/PlayerAnim/PlayerCam/UI/GameOverScreen/MainMenuButton.pressed.connect(_on_main_menu_button_pressed)

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
		add_child(e)

func check_wave_complete():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0 and not game_over_shown:
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
	var player = $Player
	if player.current_health <= 0 and not game_over_shown:
		game_over_shown = true
		show_game_over()

func show_game_over():
	var screen = $Player/PlayerAnim/PlayerCam/UI/GameOverScreen
	screen.visible = true

	var tween = create_tween()
	if screen.has_node("Background"):
		tween.tween_property(screen.get_node("Background"), "modulate:a", 1.0, 0.4)
	if screen.has_node("GameOverLabel"):
		tween.tween_property(screen.get_node("GameOverLabel"), "modulate:a", 1.0, 0.4).set_delay(0.15)
	if screen.has_node("StatsLabel"):
		tween.tween_property(screen.get_node("StatsLabel"), "modulate:a", 1.0, 0.4).set_delay(0.3)
	if screen.has_node("RestartButton"):
		tween.tween_property(screen.get_node("RestartButton"), "modulate:a", 1.0, 0.4).set_delay(0.45)
	if screen.has_node("MainMenuButton"):
		tween.tween_property(screen.get_node("MainMenuButton"), "modulate:a", 1.0, 0.4).set_delay(0.6)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
