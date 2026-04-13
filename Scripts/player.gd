extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var main: Node2D = $"../"
@onready var bob = load("res://Scenes/bob.tscn")
@onready var player: CharacterBody2D = $"."
@export var thrown: bool = false
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
	if thrown == false:
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
			face = 1
		elif direction == -1.0:
			animated_sprite_2d.flip_h = true
			face = -1

func set_for_throw():
	var instance = bob.instantiate()
	main.add_child(instance)
	thrown = true
	line_2d.make_raycast = true

func throw():
	line_2d.make_raycast = false

func reel():
	main.get_child(-2).get_child(2).get_child(1).set_node_b('')
	print(main.get_child(-2).get_child(2).get_child(1).get_node_b())
	if main.get_child(-1):
		main.get_child(-1).queue_free()
		thrown = false


func _input(event):
	if event.is_action_pressed("throw") and thrown == false:
		set_for_throw()
		
	elif Input.is_action_just_released("throw") and thrown == true:

		throw()
	elif event.is_action_pressed("throw") and thrown == true:

		reel()
