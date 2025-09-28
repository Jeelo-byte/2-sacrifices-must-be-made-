extends Control

@onready var background = $Background
@onready var game_over_label = $GameOverLabel
@onready var restart_button = $RestartButton
@onready var stats_label = $StatsLabel

signal game_over_shown

func _ready():
	visible = false
	set_process_input(false)

func show_game_over():
	visible = true
	set_process_input(true)
	get_tree().paused = true
	
	var main_node = get_node("../../Main") 
	if main_node:
		stats_label.text = "Final Wave: " + str(main_node.current_wave)
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel().tween_property(background, "modulate", Color(1, 0, 0, 0.7), 1.5)
	tween.parallel().tween_property(game_over_label, "modulate", Color.WHITE, 2.0)
	tween.parallel().tween_property(restart_button, "modulate", Color.WHITE, 2.5)
	tween.parallel().tween_property(stats_label, "modulate", Color.WHITE, 2.5)
	
	game_over_shown.emit()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("LMB"):
		restart_game()

func _on_restart_button_pressed():
	restart_game()

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
