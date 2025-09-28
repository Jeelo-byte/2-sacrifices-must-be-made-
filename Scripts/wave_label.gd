extends Label

var player

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	player = get_tree().get_first_node_in_group("player")
	if player:
		position = player.global_position + 0.7 * get_viewport_rect().size
	
	var font = load("res://Fonts/PrStart.ttf")
	if font:
		add_theme_font_override("font", font)
		add_theme_font_size_override("font_size", 48)
	
	add_theme_color_override("font_color", Color.WHITE)
	call_deferred("setup")

func setup():
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		update_wave_display()

func _process(delta):
	if player:
		update_wave_display()

func update_wave_display():
	player = get_tree().get_first_node_in_group("player")
	if player:
		var v = get_viewport_rect().size
		v.y = -v.y
		v.x = 0.7 * v.x
		position = player.global_position + v
	var enemies_left = get_tree().get_nodes_in_group("enemies").size()
	var world = get_tree().get_root().get_node("world")
	text = "WAVE: " + str(world.current_wave) + "\nENEMIES: " + str(enemies_left)
