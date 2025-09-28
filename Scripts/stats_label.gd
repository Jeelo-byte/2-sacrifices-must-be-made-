extends Label
var player

func _ready():
	var font = load("res://Fonts/PrStart.ttf")
	if font:
		add_theme_font_override("font", font)
		add_theme_font_size_override("font_size", 24)
	
	call_deferred("setup")

func setup():
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		update_wave_display()

func _process(delta):
	if player:
		update_wave_display()

func update_wave_display():
	var enemies = get_tree().get_root().get_node("world").enemies_killed
	print(enemies)
	var world = get_tree().get_root().get_node("world").current_wave
	text = "YOU HAVE FOUGHT VALIANTLY, DOCTOR.\nWAVES SURVIVED: " + str(world - 1) + "\nENEMIES SLAIN: " + str(enemies)
