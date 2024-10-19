extends MeshInstance3D

@onready var target_orbit_point: Node3D = $TargetOrbitPoint

var randRangeval : int = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Spawn position should be within the bounds of the world.
	var random = RandomNumberGenerator.new()
	random.randomize()
	self.global_position.x = random.randi_range(-randRangeval, randRangeval) 
	self.global_position.z = random.randi_range(-randRangeval, randRangeval)
	#
	#var targetVectorPosition = Vector2(self.global_position.x, self.global_position.z)
	#var rotatePoint : int = self.global_position.x - 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#self.rotate(Vector3(0,1,0), 0.015)
	pass
