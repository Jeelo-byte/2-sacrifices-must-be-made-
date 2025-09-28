extends RigidBody2D

func _ready():
	add_to_group("bullets")
	gravity_scale = 0
