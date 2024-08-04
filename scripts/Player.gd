extends Node2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var left_hand: AnimatedSprite2D = $Body/LeftHand/LeftHandSprite
@onready var right_hand: AnimatedSprite2D = $Body/RightHand/RightHandSprite
@onready var head: RigidBody2D = $Body/Head

@onready var left_hand_target: Marker2D = $Body/LeftHand/LeftHandTarget
@onready var right_hand_target: Marker2D = $Body/RightHand/RightHandTarget

@onready var left_hand_origin: Marker2D = $Body/Head/LeftHandOrigin
@onready var right_hand_origin: Marker2D = $Body/Head/RightHandOrigin

@onready var left_hand_area: Area2D = $Body/LeftHand/LeftHandSprite/LeftHandArea
@onready var right_hand_area: Area2D = $Body/RightHand/RightHandSprite/RightHandArea

@export var hand_speed: float = 1.5
@export var hand_length: int = 200


func _process(delta):
	var holding_left = false
	var holding_right = false
	
	if Input.is_action_pressed("lhand_grab") && left_hand_area.has_overlapping_areas():
		left_hand.animation = "grab"
		holding_left = true
	else:
		var direction = Input.get_vector("lhand_move_left", "lhand_move_right", "lhand_move_up", "lhand_move_down")
		move_hand(left_hand, left_hand_target, direction, left_hand_origin.global_position, delta)
		left_hand.animation = "idle"
	
	if Input.is_action_pressed("rhand_grab") && right_hand_area.has_overlapping_areas():
		right_hand.animation = "grab"
		holding_right = true
	else:
		var direction = Input.get_vector("rhand_move_left", "rhand_move_right", "rhand_move_up", "rhand_move_down")
		move_hand(right_hand, right_hand_target, direction, right_hand_origin.global_position, delta)
		right_hand.animation = "idle"
	
	if holding_left || holding_right:
		head.freeze = true
		var mid_point = (left_hand.global_position + right_hand.global_position) / 2
		head.global_position = head.global_position.lerp(mid_point, delta * 10)
		head.global_position.y += 2
	else:
		head.freeze = false
		#left_hand.global_position = left_hand_origin.global_position
		#right_hand.global_position = right_hand_origin.global_position

func move_hand(hand: Node2D, target: Node2D, direction: Vector2, origin: Vector2, delta: float) -> void:
	target.global_position = origin
	target.global_position += (direction * 1000).limit_length(hand_length)

	var hand_direction = (target.global_position - origin).normalized()
	var distance = origin.distance_to(target.global_position)

	if distance > hand_length:
		target.global_position = origin + (direction * hand_length)

	hand.global_position = hand.global_position.lerp(target.global_position, hand_speed * delta)
	hand.look_at(target.global_position)
