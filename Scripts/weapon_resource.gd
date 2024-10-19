extends Resource

class_name Weapon_Resource

@export var Weapon_Name: String
@export var Activate_Anim: String
@export var Shoot_Anim: String
@export var Reload_Anim: String
@export var Deactivate_Anim: String
@export var Out_Of_Ammo_Anim: String

@export var Current_Ammo: int
@export  var Reserve_Ammo: int
@export var Magazine_Size: int	# How much is in the reload into the gun.
@export var Max_Ammo_Reserve: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
