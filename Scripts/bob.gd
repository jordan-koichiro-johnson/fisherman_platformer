extends RigidBody2D
@export var IndexInArray: int
@onready var Bob: Node2D = $".."
@onready var Main = get_parent().get_parent()
@onready var Boost
var dir : float
var spawnPos : Vector2


func _ready() -> void:
	print(Main)
	set_contact_monitor(true)
	var velocity = Main.find_child("raycast",true,false).velocity
	Boost = velocity
	apply_impulse(velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OneTimeImpact"):
		print("one time impact")
		apply_impulse(Boost)
