extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var main: Node2D = $"../"
@onready var bob = load("res://Scenes/bob.tscn")
@onready var player: CharacterBody2D = $"."
@onready var thrown = 0
@onready var line_and_sinker: Node2D
@onready var face: int #1 is right -1 is left
@onready var line_2d: Line2D = $"../Line2D"
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
	var rodOffsetFromPlayer = Vector2(-47, -30)
	instance.position = player.position + rodOffsetFromPlayer * Vector2(face,1)
	if main.get_child(3):
		main.get_child(3).free()
	main.add_child(instance)
	var ball_and_rope = instance.get_children()
	var x = 0
	for i in ball_and_rope:
		if i is PinJoint2D and x < ball_and_rope.size()-1:
			var path_a = i.get_parent().get_child(x-1).get_path()
			var path_b = i.get_parent().get_child(x+1).get_path()
			i.set_node_a(path_a)
			i.set_node_b(path_b)
		elif i is PinJoint2D:
			var path_a = i.get_parent().get_child(x-1).get_path()
			i.set_node_a(path_a)
			i.set_node_b("/root/main/Player/Line")
		x = x+1
	thrown = 1
	return instance

func throw():
	print("length",line_2d.length)
	var ball = line_and_sinker.find_child("bob")
	print(ball)
	ball.apply_impulse(Vector2(face * SPEED,-100))
	thrown = 2

#func addNode():
	#var new_RigidBody2d = RigidBody2D.new()
	#var new_PinJoint2d = PinJoint2D.new()
	#var new_Sprite2d = Sprite2D.new()
	#var new_CollisionShape2d = CollisionShape2D.new()
	#var childrenArr = line_and_sinker.get_children()
	#var Capsule = CapsuleShape2D.new()
	#
	#print(childrenArr[1], childrenArr[0])
	#new_RigidBody2d.name = "createdbody"
	#new_PinJoint2d.name = "createdpinjoint"
	#new_Sprite2d.texture = load("res://assets/images/Items/fishing line.png")
	#new_Sprite2d.scale = Vector2(0.979, 0.438)
	#Capsule.radius = 1
	#Capsule.height = 16
	#new_CollisionShape2d.shape = Capsule
	#new_RigidBody2d.add_child(new_Sprite2d)
	#new_RigidBody2d.add_child(new_CollisionShape2d)
	#line_and_sinker.add_child(new_PinJoint2d)
	#line_and_sinker.add_child(new_RigidBody2d)
	#new_PinJoint2d.set_node_a(childrenArr[0].get_path())
	#new_PinJoint2d.set_node_b(new_RigidBody2d.get_path())
	#childrenArr[1].set_node_a(new_RigidBody2d.get_path())
	#line_and_sinker.move_child(line_and_sinker.get_child(-2), 1)
	#line_and_sinker.move_child(line_and_sinker.get_child(-1), 2)




func throwNakedBall():
	var new_RigidBody2d = RigidBody2D.new()
	var new_Sprite2d = Sprite2D.new()
	var new_CollisionShape2d = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	
	circle.radius = 3
	main.add_child(new_RigidBody2d)
	new_Sprite2d.texture = load("res://assets/images/Items/fishing bob.png")
	new_CollisionShape2d.shape = circle
	new_RigidBody2d.global_position = player.global_position
	new_RigidBody2d.add_child(new_Sprite2d)
	new_RigidBody2d.add_child(new_CollisionShape2d)

	new_RigidBody2d.apply_impulse(Vector2(1000, -1000))
	print(new_CollisionShape2d.get_shape())

func reel():
	var ball = line_and_sinker.get_children()
	for i in ball:
		print(i.get('velocity'))
		if i.get('velocity'):
			i.velocity = Vector2(0,0)
	if main.get_child(3):
		main.get_child(3).free()
	thrown = 0

func _input(event):
	if event.is_action_pressed("throwNakedBall"):
		throwNakedBall()
	#if event.is_action_pressed(("addNode")) and thrown == 1:
		#addNode()
	if event.is_action_pressed("throw") and thrown == 0:
		line_and_sinker = set_for_throw()
		print("length in plyaer", line_2d.length)
	elif event.is_action_pressed("throw") and thrown == 1:
		throw()
	elif event.is_action_pressed("throw") and thrown == 2:
		reel()
#creating pull request
