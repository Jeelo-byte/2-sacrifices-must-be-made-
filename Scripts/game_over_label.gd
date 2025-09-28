extends Label

@onready var my_label: Label = get_node("GameOverLabel")

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_node("PlayerAnim/PlayerCam"):
		var cam = player.get_node("PlayerAnim/PlayerCam").global_position
		my_label.global_position = cam - get_viewport().size / 2 - Vector2(200, 0)
