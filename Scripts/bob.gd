extends RigidBody2D
@export var IndexInArray: int
@onready var Bob: Node2D = $".."

@export var SPEED = 100

var dir : float
var spawnPos : Vector2
var velocity : Vector2 = Vector2(100000,-100000)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OneTimeImpact"):
		print("one time impact")
		apply_impulse(velocity)
