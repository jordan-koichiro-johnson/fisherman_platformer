extends RigidBody2D
@export var IndexInArray: int
@onready var Bob: Node2D = $".."


var velocity = Vector2(10000, -10000)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	

func _input(event):
	if event.is_action_pressed("OneTimeImpact"):
		apply_impulse(velocity)

#func _physics_process(delta: float) -> void:
	#move_and_collide(Vector2(0,0))
