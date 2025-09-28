extends Button

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	if player:
		position = player.global_position
		position.y = position.y + 300

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		position = player.global_position - get_viewport_rect().size * 0.88
		position.y = position.y + 850
		custom_minimum_size = Vector2(2000, 200)
