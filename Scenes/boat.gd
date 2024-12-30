extends RigidBody3D

@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export var float_force := 1.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var hori: Node3D = $Hori
@onready var verti: Node3D = $Hori/Verti
@onready var water_plane = get_node('/root/Water_World/WaterPlane')

@onready var floaty_contaier = $FloatyContaier.get_children()
@onready var camera_3d: Camera3D = $Hori/Verti/Camera3D

var mouse_movement = Vector2()
#var current_velocity : Vector3 = (linear_velocity * transform.basis.transposed())
var moving_rotational_degrees = 0.5
var stationary_rotational_degrees = 0.4
var submerged := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # MOUSE_MODE_CAPTURED = 2
		
	elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			

# Central force will propell the whole boat as 1 unit, 
# apply force will do the individual floaties.

#func camera_rotation_gyro() -> void:
	#var input = hori.rotation_degrees / 360
	#
	#if input > 0.5:
		#input *=-1
	#var output = input - 2
	#pass

func floaty_physics() -> void:
	submerged = false
	for floaty in floaty_contaier:
		#if str(floaty).contains("Floaty"):
		var depth = water_plane.get_height(floaty.global_position) - floaty.global_position.y
		if depth > 0:
			#print(floaty)
			submerged = true
			apply_force( Vector3.UP * float_force * gravity * depth, floaty.global_position - global_position )
			#print(float_force, gravity, depth, floaty.global_position - global_position)
			#print(rotation_degrees.x)
			#apply_central_force(Vector3.UP * 1 * -floaty.global_transform.origin)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
		
func _physics_process(_delta: float) -> void:
	#var floaties = get_tree().get_nodes_in_group("Boat_Nodes")
	
	# NOTE: This works, but only for the back of the vehicle.
	#if hori.rotation_degrees.y > 360 or hori.rotation_degrees.y < -360:
		#hori.rotation_degrees.y = 0
	#print(hori.rotation_degrees.y)
	#if hori.rotation_degrees.y >= -10 and hori.rotation_degrees.y <= 10:
		#hori.rotation_degrees.z = rotation_degrees.z * -1
	#elif hori.rotation_degrees.y >= 80 and hori.rotation_degrees.y <= 100:
		#hori.rotation_degrees.z = rotation_degrees.z * 0.5
	#elif hori.rotation_degrees.y >= 170 and hori.rotation_degrees.y <= 190:
		#hori.rotation_degrees.z = rotation_degrees.z
	#elif hori.rotation_degrees.y >= 260 and hori.rotation_degrees.y <= 280:
		#hori.rotation_degrees.z = rotation_degrees.z * -0.5
	hori.global_position = global_position
	hori.global_position.y = global_position.y + 0
	hori.global_position.z = global_position.z + 0
	#hori.global_rotation = global_rotation
		
	

	#hori.rotation_degrees.x = rotation_degrees.x * -1
	#verti.rotation_degrees.y = rotation_degrees.y * -1
	#hori.RotationEditMode
	#hori.rotation_degrees.x = -rotation_degrees.x
	
	
	
	if mouse_movement != Vector2() and Input.get_mouse_mode() == 2: # Checking for MOUSE_MODE_CAPTURED
#		NOTE 1st person position: X 0.747, Y 5.127, Z -4.435
#		NOTE 3rd person position: X 0, Y 3.11, Z -5.716
		hori.rotation_degrees.y -= mouse_movement.x
		verti.rotation_degrees.x += mouse_movement.y
		
		hori.rotation_degrees.z = 0
		verti.rotation_degrees.z = 0
		
		if verti.rotation_degrees.x <= -40:
			verti.rotation_degrees.x = -40
		if verti.rotation_degrees.x >= 0:
			verti.rotation_degrees.x = 0
		mouse_movement = Vector2()

#	Movement is propulsion based, right now it puts the force from the direction of the vector.
	if Input.is_action_pressed( "Forward" ):
		apply_central_force( global_transform.basis * Vector3.BACK * 150)
		var h = hori.rotation_degrees
		#print("X: ", h.x, " Y: ", h.y, " Z: ", h.z)
		#print("Y: ", camera_3d.rotation_degrees.y)
		#print("Z: ", h.z)

	elif Input.is_action_pressed( "Backward" ):
		apply_central_force( global_transform.basis * Vector3.FORWARD * 100)

	if Input.is_action_pressed( "Right" ):
		apply_torque( Vector3( 0,-5,0 ))

	if Input.is_action_pressed( "Left" ):
		apply_torque( Vector3( 0,5,0 ) )

	floaty_physics()
	
	#if $Floaty.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty.global_transform.origin, $Floaty.global_transform.origin - global_transform.origin)	
	#if $Floaty2.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty2.global_transform.origin, $Floaty2.global_transform.origin - global_transform.origin)	
	#if $Floaty3.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty3.global_transform.origin, $Floaty3.global_transform.origin - global_transform.origin)	
	#if $Floaty4.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty4.global_transform.origin, $Floaty4.global_transform.origin - global_transform.origin)	
#
# TODO: Make ship influenced by wind
# TODO: Make the water infinitly traversable
# TODO: Make ship move autonomously
# TODO: Make ship traversible while in motion.
# TODO: Make underwater camera effect
# TODO: Make camera Stable to world rather than boat
# TODO: Make ship Sails have different states, either progressive, or finite
# TODO: Make ship wheel activatable
# TODO: Make ship climb-able via hull and rigging?
# TODO: Make ship dockable
# TODO: Add an anchor.
# TODO: Adjust camera for 1st person
# TODO: Add in storms
# DONE: Add in waves via shader
# DONE: Make things float via the shader
#DONE Apply torque doesn't seem to be working, rotational_degrees will work for now. 
# DONE: Figure out why this seems to be causing an infinite error after the floaties touch the water. It seems to be the floaties themselves.
# DONE: Dividing the floaty global by global is the issue. Probably a divide by zero error.
# DONE: Fix Boat being still jittery once entering the water
# DONE: Determine the best use case for central force and apply force. 
# DONE: Figure out why adding the animation player inverts the starting rotation by 180 deg. for the boat
# DONE Make all the floating boxes float as rigidbody3ds and physics	
