extends RigidBody3D

class_name PickupCompass

var item_name = "Spyglass"

#@export var item_name: String
@export var current_ammo: int
@export var reserve_ammo: int

var dropped = false

func _process(_delta: float) -> void:
	if dropped == true:
		apply_impulse(transform.basis.z,-transform.basis.z * 10)
		dropped = false
