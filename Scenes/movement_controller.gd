extends Node

@export var Ship : RigidBody3D
@export var LowPolyShip : Node3D
#@export var rotation_speed: float = 0

var movement_speed : float
var camera_fov : float
var turning_speed : float


#func _physics_process(delta: float) -> void:
	#Ship.apply_central_force(Vector3(  ))

func _on_set_movement_state(_movement_state : MovementState):
	movement_speed = _movement_state.movement_speed
	turning_speed = _movement_state.turning_speed
	print("Getting movement from the movementController ")
#func _on_set_movement_direction(_movement_direction : )
