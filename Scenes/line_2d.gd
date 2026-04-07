extends Line2D

@onready var line_2d: Line2D = $"."
@onready var player: CharacterBody2D = $"../Player"
@onready var collision_shape_2d: CollisionShape2D = $"../StaticBody2D/CollisionShape2D"
@onready var static_body_2d: StaticBody2D = $"../StaticBody2D"
@onready var throw_power = 0
@export var length: float
const SPEED = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_trajectory(delta):
	# making trajectory line for throw
	if throw_power < 1000:
		throw_power = throw_power + 5
	var max_points = 300
	clear_points()
	var pos = player.global_position
	var vel = Vector2(SPEED + throw_power,-100 - throw_power)
	var grav = player.get_gravity()
	var total_length = 0.0
	for i in max_points:
		line_2d.add_point(pos)
		vel.y += grav.y * delta
		var prev_pos = pos
		pos += vel * delta
		total_length += pos.distance_to(prev_pos)
		if pos.y > collision_shape_2d.global_position.y:
			return(total_length)

func _process(delta):
	if player.thrown == 1:
		length = update_trajectory(delta)
	elif player.thrown == 2:
		clear_points()
		throw_power = 0
