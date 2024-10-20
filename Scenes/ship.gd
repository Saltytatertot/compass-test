extends VehicleBody3D

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("Right", "Left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("Backward","Forward") * ENGINE_POWER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
