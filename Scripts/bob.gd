extends RigidBody2D
#@onready var rigid_body_2d: RigidBody2D = $"../RigidBody2D"
@export var IndexInArray: int
@onready var Bob: Node2D = $".."

@export var SPEED = 100

var dir : float
var spawnPos : Vector2
var velocity : Vector2 = Vector2(100,100)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		if get_parent().get_parent().find_child("Player").thrown == 1:
			apply_impulse(velocity)

#func _ready():
	#print(velocity)
	#apply_impulse(velocity)

func _physics_process(delta):
	move_and_collide(velocity)
