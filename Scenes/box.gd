extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pile = get_tree().get_nodes_in_group("Debris")
	for debris in pile:
		if str(debris).contains("Debris"):
			debris.mass = 0.05
			debris.gravity_scale = 0.8
			debris.inertia = Vector3(0.1, 0.5, 0.1)
			debris.linear_damp = 1
			debris.angular_damp = 0.1

#Calculating the debris physics
func debris_physics(pile) -> void:
	for debris in pile:
		if str(debris).contains("Debris"):
			if debris.global_transform.origin.y <= 0:
				#print(debris)
				#debris.apply_force( Vector3.UP * 1 * -debris.global_transform.origin , debris.global_transform.origin - global_transform.origin )
				debris.apply_central_force(Vector3.UP * 5 * -debris.global_transform.origin)
			#if debris_collision_shape_3d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#var pile = get_tree().get_nodes_in_group("Debris")
	var pile = get_tree().get_nodes_in_group("Debris")
	debris_physics(pile)
