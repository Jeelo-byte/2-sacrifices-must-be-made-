extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@export var damage_amount: int = 1
@export var attack_cooldown: float = 1.0
var move_speed = 200
var can_attack: bool = true

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	var direction = (player.position - position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		queue_free()
		body.queue_free()
		if get_parent().has_method("enemy_killed"):
			get_parent().enemy_killed()
	elif body == player and can_attack:
		player.take_damage(damage_amount)
		can_attack = false
		get_tree().create_timer(attack_cooldown).timeout.connect(func(): can_attack = true)
