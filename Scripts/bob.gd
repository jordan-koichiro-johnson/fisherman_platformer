extends RigidBody2D
@onready var rigid_body_2d: RigidBody2D = $"../RigidBody2D"


@export var SPEED = 100

var dir : float
var spawnPos : Vector2
var velocity : Vector2


#func _ready():
	#apply_impulse(velocity)

#func _physics_process(delta):
	#move_and_collide(velocity)
