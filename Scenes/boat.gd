extends RigidBody3D

@onready var hori: Node3D = $Hori
@onready var verti: Node3D = $Hori/Verti

var mouse_movement = Vector2()
var current_velocity : Vector3 = (linear_velocity.normalized() * transform.basis).normalized()
var tree_string = get_tree_string()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func floaty_physics(floaties) -> void:
	for floaty in floaties:
		if str(floaty).contains("Floaty"):
			if floaty.global_transform.origin.y <= 0:
				apply_force(Vector3.UP.normalized()*50*-floaty.global_transform.origin.normalized(), floaty.global_transform.origin.normalized() / global_transform.origin.normalized())
	
func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
		
func _physics_process(delta: float) -> void:
	var floaties = get_tree().get_nodes_in_group("Boat_Nodes")
	
	if mouse_movement != Vector2():
		hori.rotation_degrees.y -= mouse_movement.x
		verti.rotation_degrees.x -= mouse_movement.y
		if verti.rotation_degrees.x <= -90:
			verti.rotation_degrees.x = -90
		if verti.rotation_degrees.x >= 0:
			verti.rotation_degrees.x = 0
		mouse_movement = Vector2()

	#var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
			#
	if Input.is_action_pressed("Forward"):
		add_constant_central_force(current_velocity)
		if Input.is_action_pressed("Right"):
			add_constant_torque(Vector3(0,5,0).normalized())
		if Input.is_action_pressed("Left"):
			add_constant_torque(Vector3(0,-5,0).normalized())
	elif Input.is_action_pressed("Backward"):
		add_constant_central_force(-current_velocity)
		if Input.is_action_pressed("Right"):
			add_constant_torque(Vector3(0,5,0).normalized())
		if Input.is_action_pressed("Left"):
			add_constant_torque(Vector3(0,-5,0).normalized())

	#if $Floaty.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty.global_transform.origin, $Floaty.global_transform.origin - global_transform.origin)	
	#if $Floaty2.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty2.global_transform.origin, $Floaty2.global_transform.origin - global_transform.origin)	
	#if $Floaty3.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty3.global_transform.origin, $Floaty3.global_transform.origin - global_transform.origin)	
	#if $Floaty4.global_transform.origin.y <= 0:
				#apply_force(Vector3.UP*1*-$Floaty4.global_transform.origin, $Floaty4.global_transform.origin - global_transform.origin)									
#
	floaty_physics(floaties)
	
	
	
	
	
