extends Node3D
@onready var water_plane: MeshInstance3D = $"../WaterPlane"
@export var float_force := 1.00
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var debrisGroup = get_children()


@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for debris in debrisGroup:
		
	#var pile = get_tree().get_nodes_in_group("Debris")
	#for debris in pile:
		if str(debris).contains("Debris"):
			debris.mass = 1.25
			debris.gravity_scale = 1.0
			debris.inertia = Vector3(0.1, 0.5, 0.1)
			debris.linear_damp = 1
			debris.angular_damp = 0.1

#Calculating the debris physics
func debris_physics(pile) -> void:
	for debris in debrisGroup:
		var depth = water_plane.get_height(debris.global_position) - debris.global_position.y
		#if str(debris).contains("Debris"):
		if depth > 0:
			submerged = true
			#print(debris)
			#debris.apply_force( Vector3.UP * 1 * -debris.global_transform.origin , debris.global_transform.origin - global_transform.origin )
			debris.apply_central_force(Vector3.UP * float_force * gravity * depth)
			#if debris_collision_shape_3d
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity  *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#var pile = get_tree().get_nodes_in_group("Debris")
	var pile = get_tree().get_nodes_in_group("Debris")
	debris_physics(pile)
