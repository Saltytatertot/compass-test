extends RigidBody3D

@onready var hori: Node3D = $Hori
@onready var verti: Node3D = $Hori/Verti

var mouse_movement = Vector2()
var current_velocity : Vector3 = (linear_velocity * transform.basis.transposed())
var moving_rotational_degrees = 0.5
var stationary_rotational_degrees = 0.4

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		print(Input.get_mouse_mode())
		
	elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
# DONE: Figure out why this seems to be causing an infinite error after the floaties touch the water. It seems to be the floaties themselves.
# DONE: Dividing the floaty global by global is the issue. Probably a divide by zero error.

#TODO: Fix Boat being still jittery once entering the water
func floaty_physics(floaties) -> void:
	for floaty in floaties:
		if str(floaty).contains("Floaty"):
			if floaty.global_transform.origin.y <= 0:
				#print(floaty)
				apply_force( Vector3.UP * 5 * -floaty.global_transform.origin , floaty.global_transform.origin - global_transform.origin )
	
#func _ready() -> void:
	##Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
		
func _physics_process(_delta: float) -> void:
	var floaties = get_tree().get_nodes_in_group("Boat_Nodes")
	
	if mouse_movement != Vector2() and Input.get_mouse_mode() == 2:
		hori.rotation_degrees.y -= mouse_movement.x
		verti.rotation_degrees.x += mouse_movement.y
		if verti.rotation_degrees.x <= -40:
			verti.rotation_degrees.x = -40
		if verti.rotation_degrees.x >= 0:
			verti.rotation_degrees.x = 0
		mouse_movement = Vector2()

	#var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
			#
#	Movement is propulsion based, right now it puts the force from the direction of the vector.
#	DONE Apply torque doesn't seem to be working, rotational_degrees will work for now. 
	if Input.is_action_pressed( "Forward" ):
		apply_central_force( global_transform.basis * Vector3.BACK * 15)


	if Input.is_action_pressed( "Backward" ):
		apply_central_force( global_transform.basis * Vector3.FORWARD * 10)

	#
	if Input.is_action_pressed( "Right" ):
		apply_torque( Vector3( 0,-0.5,0 ))

		

	if Input.is_action_pressed( "Left" ):
		apply_torque( Vector3( 0,0.5,0 ) )

	floaty_physics(floaties)
	
	#if $Floaty.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty.global_transform.origin, $Floaty.global_transform.origin - global_transform.origin)	
	#if $Floaty2.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty2.global_transform.origin, $Floaty2.global_transform.origin - global_transform.origin)	
	#if $Floaty3.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty3.global_transform.origin, $Floaty3.global_transform.origin - global_transform.origin)	
	#if $Floaty4.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty4.global_transform.origin, $Floaty4.global_transform.origin - global_transform.origin)	
#
	
	
	
	
	
