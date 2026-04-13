extends RigidBody2D
@export var IndexInArray: int
@onready var Bob: Node2D = $".."

@export var SPEED = 100

var dir : float
var spawnPos : Vector2
