extends Label

var player

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	position = Vector2(20, 20)
	
	var font = load("res://Fonts/PrStart.ttf")
	if font:
		add_theme_font_override("font", font)
		add_theme_font_size_override("font_size", 24)
	
	call_deferred("setup")

func setup():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_health_changed)
		text = "HP: " + str(player.current_health) + "/" + str(player.max_health)

func _on_health_changed(current: int, maximum: int):
	text = "HP: " + str(current) + "/" + str(maximum)

func _process(delta):
	if player and is_instance_valid(player):
		text = "HP: " + str(player.current_health) + "/" + str(player.max_health)
