extends Node3D

@onready var target: MeshInstance3D = $".."
#@onready var target_orbit_point_label: Label3D = $TargetOrbitPointLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position.x = target.global_position.x - 0.75
	self.global_position.z = target.global_position.z - 0.75
	#target.global_position.y - 15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#target_orbit_point_label.text = str("Point Position: ", target.global_position)
	#target.rotate(Vector3(0,1,0), 0.11)
	target.rotate_y(0.01)
	#target.rotate_x(0.11)
	
	#target.rotate(Vector3(0,0,1), 0.11)
	#target.rotate(Vector3(1,0,0), 0.11)
	
	pass
	
