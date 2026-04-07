extends Node2D
@onready var Bob: Node2D = $"."
@onready var IntervalScaleFactor = 0.03
@onready var rope_start: StaticBody2D = $"/root/main/Player/Line"
@onready var rope_end: RigidBody2D = $bob
@onready var packed_scene = load("res://Scenes/ropesegment.tscn")
@onready var start_pin_joint: PinJoint2D = $"/root/main/Player/Line/PinJoint2D"
@onready var end_pin_joint: PinJoint2D = $RopeEnd/PinJoint2D
@onready var rope_points_line: Array
@onready var line_2d: Line2D = $Line2D
@onready var rope_segments: Array
@onready var raycast: Line2D = $"../raycast"
@onready var rope_spawned = false
@onready var player: CharacterBody2D = $"/root/main/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func spawnRope():
	print(player)
	var rope_starting_position = player.get_child(2).get_child(0).global_position
	var rope_ending_position = player.global_position
	print(raycast.length)
	var distance = raycast.length
	var base_interval = 10
	var interval = base_interval +(distance * IntervalScaleFactor)
	var direction = (rope_ending_position - rope_starting_position).normalized()
	var number_of_segments = snapped(distance/interval, 1)
	var rotation_angle = direction.angle() - PI / 2
	rope_start.IndexInArray = 0
	var current_position = rope_starting_position
	var latest_segment = rope_start
	rope_segments.clear()
	rope_segments.append(latest_segment)
	for i in number_of_segments:
		current_position += direction * interval
		latest_segment = addRopeSegment(latest_segment, i+1, rotation_angle, current_position)
		rope_segments.append(latest_segment)
		
		var joint_position = latest_segment.get_node("PinJoint2D").global_position
		if joint_position.distance_to(rope_ending_position) < interval:
			break
	connectRopeParts(rope_end, latest_segment)
	rope_end.rotation = rotation_angle
	rope_segments.append(rope_end)
	rope_end.IndexInArray = number_of_segments

func connectRopeParts(a, b):
	var pinJoint = a.find_child("PinJoint2D")
	pinJoint.set_node_a(a.get_path())
	pinJoint.set_node_b(b.get_path())
	

func addRopeSegment(previous_segment, i, rotation_angle, position):
	var pinJoint = previous_segment.find_child("PinJoint2D")
	var segment = packed_scene.instantiate()
	segment.global_position = position
	segment.rotation = rotation_angle
	

	segment.IndexInArray = i
	Bob.add_child(segment)
	pinJoint.set_node_a(previous_segment.get_path())
	pinJoint.set_node_b(segment.get_path())
	pinJoint.set_bias(0.99)
	pinJoint.set_softness(0.003)
	return(segment)

func update_line_2d_rope():
	rope_points_line.clear()
	rope_points_line.append(start_pin_joint.global_position)
	for i in rope_segments:
		rope_points_line.append(i.global_position)
	rope_points_line.append(end_pin_joint.global_position)
	line_2d.points = rope_points_line

func _input(event):
	if event.is_action_pressed("throw"):
		print("bobinput")
		spawnRope()
		rope_spawned = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_line_2d_rope()
