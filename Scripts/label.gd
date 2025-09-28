extends Label
var player

func _ready():
	
	
	# Make sure we're in a CanvasLayer or at scene root level
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	player = get_tree().get_first_node_in_group("player")
	if player:
		position = player.global_position - get_viewport_rect().size
	var font = load("res://Fonts/PrStart.ttf")
	if font:
		add_theme_font_override("font", font)
		add_theme_font_size_override("font_size", 48)
	
	call_deferred("setup")

func setup():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_health_changed)
		text = "HP: " + str(player.current_health) + "/" + str(player.max_health)

func _on_health_changed(current: int, maximum: int):
	text = "HP: " + str(current) + "/" + str(maximum)

func _process(delta):
	player = get_tree().get_first_node_in_group("player")
	if player:
		var w = get_viewport_rect().size
		w.x = 1.1 * w.x
		position = player.global_position - w
	if player and is_instance_valid(player):
		text = "HP: " + str(player.current_health) + "/" + str(player.max_health)
