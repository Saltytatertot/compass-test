extends RigidBody3D

signal set_movement_state(_movement_state: MovementState)

@export var water_drag := 0.05
@export var water_angular_drag := 0.50
@export var float_force := 1.0
@export var forward_const_force = 400
@export var backward_const_force = 0.75 * forward_const_force
@export var rotational_const_force = 30

@export var movement_states : Dictionary

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water_plane: MeshInstance3D = $"../WaterPlane"

@onready var floaty_contaier = $FloatyContaier.get_children()
@onready var ocean: Node3D = $"../Ocean"

var mouse_movement = Vector2()
#var current_velocity : Vector3 = (linear_velocity * transform.basis.transposed())
var moving_rotational_degrees = 0.5
var stationary_rotational_degrees = 0.4
var submerged := false

#
#func _ready():
	#set_movement_state.emit(movement_states["idle"])


func floaty_physics() -> void:
	submerged = false
	for floaty in floaty_contaier:
		var depth = water_plane.get_height(floaty.global_position) - floaty.global_position.y
		if depth > 0:
			submerged = true
			apply_force( Vector3.UP * float_force * gravity * depth, floaty.global_position - global_position )


func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
		
func _physics_process(_delta: float) -> void:
	floaty_physics()
	ocean.position.x = self.position.x
	ocean.position.z = self.position.z
