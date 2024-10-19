extends Node3D

var Current_Weapon = null
var Weapon_Stack = [] # Weapons/Items Currently held by the player
var Weapon_Indicator = 0 # Pointer to the currently selected weapon in the array
var Next_Weapon: String  # Pointer to the next weapon in the array
var Weapon_Dict = {} #Dictionary for all the weapons in the game

@export var _weapon_resources: Array[Weapon_Resource]	# Requires Weapon_Resource 
@export var Start_Weapons: Array[String] # Array of all weapons at the start of the game.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initialize(Start_Weapons)
	pass # Replace with function body.

func Initialize(_start_weapons: Array): # State Machine
	for weapon in _weapon_resources:
		Weapon_Dict[weapon.Weapon_Name] = weapon
		
	for i in _start_weapons:
		Weapon_Stack.push_back(i)
	
	Current_Weapon = Weapon_Dict[Weapon_Stack[0]]
	enter()
	
func enter():
	pass

func exit(_next_weapon: String): # To Change Weapons first call exit
	if _next_weapon != Current_Weapon.Weapon_Name:
		Next_Weapon = _next_weapon
	pass
	
func Change_Weapon(weapon_name: String):
	Current_Weapon = Weapon_Dict[weapon_name]
	Next_Weapon = ""
	enter()
	pass

# DONE: Change to a raycast.
# TODO: Change the signal to work on keyboard input

func _on_pick_up_detection_body_entered(body: Node3D) -> void:
	#BUG Throws an error if the CSG BOX gets in contact with the pick_up_detection collision shape
	var Weapon_in_Stack = Weapon_Stack.find(body.item_name,0)
	if Weapon_in_Stack == -1:
		Weapon_Stack.insert(Weapon_Indicator,body.weapon_name)
		
		Weapon_Dict[body.item_name].Current_Ammo = body.current_ammo
		emit_signal("Update_Weapon_Stack", Weapon_Stack)
		exit(body.weapon_name)
	#print(body.item_name)
