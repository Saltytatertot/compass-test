extends Node3D

class_name Compass

@onready var compass_mesh: MeshInstance3D = $MeshInstance3D/CompassMesh
#@onready var neck: Node3D = $"../../../.."
#var target_orbit_point = null
@onready var target: MeshInstance3D = $Target
@onready var neck: Node3D = $"../../../.."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#@onready var target: MeshInstance3D = $"../../../../../Target"
#@onready var target_orbit_point: Node3D = $"../../../../../Target/TargetOrbitPoint"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
#var dropped = false
#@onready var camera_3d: Camera3D = $"../../.."
#@onready var hand: Node3D = $"../../../../Hand"
#@onready var player: Player = $"../../../../.."

func faceDirection(compass_target):
#	Calculate the direction from the pointer to the target
	if compass_target != null:
		var parent = self.get_parent().get_parent()
		var direction_to_target = (compass_target.global_transform.origin - compass_mesh.global_transform.origin).normalized()
		#print(compass_mesh.rotation_degrees.y)
	# SOLVED 1: Compass rotation 
	# SOLUTION 1: Subtract Neck Movement From compass rotation, as the neck is the only thing that's moving in the game world, everything else is attached to it
	#	Calculate the angle for rotation around the y-axis
		var angle_y = atan2(direction_to_target.x, direction_to_target.z)
	#	Apply the rotation to the pointer around the y-axis with an additional 180 degrees offest in addition to neck offset.
		compass_mesh.rotation_degrees.y = rad_to_deg(angle_y) + 180 - parent.rotation_degrees.y
		#print(compass_mesh.rotation_degrees.y)
	#DEBUG FaceDirection
	#print(neck.rotation_degrees.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.queue( "Held_Compass_Wobble_Loop" )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	faceDirection($Target.get_child(0))
