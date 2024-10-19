#
#extends MeshInstance3D
#
#class_name Compass
#
#@export var player: Player
#@onready var target: MeshInstance3D = $"../Target"
#@onready var needle: MeshInstance3D = $Needle
#@onready var compass_mesh: Compass = $"."
#
#func faceDirection(direction, keyboard):
	#if keyboard == false:
##		global_rotation.y will make compass all wobbly
##		Would need to make y some constant value that is always above and in front of player the player.
		#look_at( Vector3(direction.x, global_position.y, direction.z), Vector3(0,1,0)) 
	#else:
		#look_at( Vector3(direction.x, global_position.y, direction.z), Vector3(0,1,0)) 
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	##var input_dir = Input.get_vector("West", "East", "North", "South")
	#var input_dir = Vector3(1,0,2)
	##var direction = (Vector3(input_dir.x, 15, input_dir.y))
	##faceDirection( input_dir, true )
#
	#var direction_to_target = (target.global_transform.origin - needle.global_transform.origin).normalized()
	#
	#var angle_y = atan2(direction_to_target.x, direction_to_target.z)
	#
	#needle.rotation_degrees.y = rad_to_deg(angle_y) + 180
#
#
	#print( self.get_global_position().x, self.get_global_position().y, self.get_global_position().z )
