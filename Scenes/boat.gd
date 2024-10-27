extends RigidBody3D

var mouse_movement = Vector2()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
		
func _physics_process(delta: float) -> void:
	if mouse_movement != Vector2():
		$Hori.rotation_degrees.y += -mouse_movement.x
		$H/V.rotation_degrees.x += -mouse_movement.y
		mouse_movement = Vector2()
