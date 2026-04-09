extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var main: Node2D = $"../"
@onready var bob = load("res://Scenes/bob.tscn")
@onready var player: CharacterBody2D = $"."
@export var thrown = 0
@onready var line_and_sinker: Node2D
@onready var face: int #1 is right -1 is left
@onready var line_2d: Line2D = $"../raycast"
@onready var max_points = 250
@onready var static_body_2d: StaticBody2D = $"../StaticBody2D"
const SPEED = 300.0
const JUMP_VELOCITY = -850.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "Run"
	else :
		animated_sprite_2d.animation = "idle"
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
		face = 1
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		face = -1

func set_for_throw():
	var instance = bob.instantiate()
	main.add_child(instance)
	thrown = 1
	return instance


func throw(instance):
	thrown = 2

func reel():
	if main.get_child(3):
		main.get_child(3).free()
	thrown = 0

func _input(event):
	if event.is_action_pressed("throw") and thrown == 0:
		line_and_sinker = set_for_throw()
		thrown = 1
	elif Input.is_action_just_released("throw") and thrown == 1:
		throw(line_and_sinker)
	elif event.is_action_pressed("throw") and thrown == 2:
		reel()
#creating pull request
