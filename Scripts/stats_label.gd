extends Label
var player

func _ready():
	var font = load("res://Fonts/PrStart.ttf")
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	if font:
		add_theme_font_override("font", font)
		add_theme_font_size_override("font_size", 60)
	
	call_deferred("setup")

func setup():
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		update_wave_display()

func _process(delta):
	if player:
		update_wave_display()

func update_wave_display():
	var enemies = get_tree().get_root().get_node("world").enemies_dead
	var world = get_tree().get_root().get_node("world").current_wave
	var player = get_tree().get_first_node_in_group("player")
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	if player:
		position = player.global_position - get_viewport_rect().size * 0.88
		position.y = position.y + 300
	text = "YOU HAVE FOUGHT VALIANTLY, DOCTOR.\nWAVES SURVIVED: " + str(world - 1) + "\nENEMIES SLAIN: " + str(enemies)
