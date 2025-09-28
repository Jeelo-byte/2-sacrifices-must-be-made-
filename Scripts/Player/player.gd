extends CharacterBody2D

@export var bullet: PackedScene
@export var bullet_speed = 1500
@export var offset_scale = 140
@export var offset_rot = 270
@export var max_health: int = 10
@export var damage_cooldown: float = 1.0

@onready var anim: AnimatedSprite2D = $PlayerAnim
signal health_changed(current_health: int, max_health: int)

var movespeed = 500
var current_health: int
var can_take_damage: bool = true

func _ready():
	add_to_group("player")
	anim.play("idle")
	current_health = max_health
	call_deferred("emit_initial_health")

func emit_initial_health():
	health_changed.emit(current_health, max_health)

func _physics_process(delta):
	var direction = Vector2()
	if current_health != 0:
		if Input.is_action_pressed("up"):
			direction.y -= 1
		if Input.is_action_pressed("down"):
			direction.y += 1
		if Input.is_action_pressed("left"):
			direction.x -= 1
		if Input.is_action_pressed("right"):
			direction.x += 1
		if Input.is_action_just_pressed("LMB"):
			fire()

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * movespeed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	look_at((get_global_mouse_position() - anim.global_position).rotated(deg_to_rad(offset_rot)) + anim.global_position)

func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = anim.global_position + offset_scale * Vector2(cos(rotation + deg_to_rad(offset_rot + 180)), sin(rotation + deg_to_rad(offset_rot + 180)))
	bullet_instance.rotation = rotation + deg_to_rad(offset_rot)
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation + deg_to_rad(offset_rot + 180)))
	get_tree().get_root().add_child(bullet_instance)

func take_damage(damage_amount: int):
	if not can_take_damage:
		return

	current_health = max(current_health - damage_amount, 0)
	health_changed.emit(current_health, max_health)
	create_damage_effect()
	can_take_damage = false
	get_tree().create_timer(damage_cooldown).timeout.connect(func(): can_take_damage = true)

func create_damage_effect():
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(anim, "modulate", Color.RED, 0.1)
	tween.tween_property(anim, "modulate", Color.WHITE, 0.1)

func die():
	current_health = 0
	var game_over_screen = get_node("../UI/GameOverScreen")
	if game_over_screen:
		game_over_screen.show_game_over()
