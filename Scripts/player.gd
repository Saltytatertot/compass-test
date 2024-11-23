extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var neck: Node3D = $Neck
@onready var camera_3d: Camera3D = $Neck/Camera3D
@onready var reach: RayCast3D = $Neck/Camera3D/Reach
@onready var hand: Node3D = $Neck/Hand
@onready var compass = preload("res://Scenes/held_compass.tscn")
@onready var pickup_compass = preload("res://Pickups/pickup_compass.tscn")
@onready var spyglass = preload("res://Scenes/held_spyglass.tscn")
@onready var pickup_spyglass = preload("res://Scenes/pickup_spyglass.tscn")

#var voidPosition: Vector3 = Vector3(0,-100,0)
var void_position: int = -100
var reset_position: Vector3 = Vector3.ONE
var weapon_to_spawn
var weapon_to_drop


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				neck.rotate_y(-event.relative.x * 0.01)
				camera_3d.rotate_x(-event.relative.y * 0.01)
				camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-50), deg_to_rad(50))
				camera_3d.rotation.z = clamp(camera_3d.rotation.z, deg_to_rad(0), deg_to_rad(0))
				camera_3d.rotation.y = clamp(camera_3d.rotation.y, deg_to_rad(-1.5), deg_to_rad(1.2))

func _process(_delta: float) -> void:
	
#	Would need refarctored a bit to put else conditions first.
	if reach.is_colliding():
		if reach.get_collider() != null and reach.get_collider().get_name().contains("PickupCompass"): # so the collider returns null
			print("Is Colliding with Compass")
			weapon_to_spawn = compass.instantiate()
		elif reach.get_collider() != null and reach.get_collider().get_name().contains("PickupSpyglass"): # so the collider returns null
			print("Is Colliding with Spyglass")
			weapon_to_spawn = spyglass.instantiate()
		else:
			weapon_to_spawn = null
	else:
		weapon_to_spawn = null
	
	if hand.get_child_count() != 0 and hand.get_child(0) != null:
		if hand.get_child(0).get_name() == "Compass":
			weapon_to_drop = pickup_compass.instantiate()
		elif hand.get_child(0).get_name() == "Spyglass":
			weapon_to_drop = pickup_spyglass.instantiate()
	else:
		weapon_to_drop = null
			
	if Input.is_action_just_pressed("Interact"):
		if weapon_to_spawn != null:
			print("Weapon Spawn Set")
			if hand.get_child_count() != 0 and hand.get_child(0) != null:
				print("Hand Free")
				print(weapon_to_drop)
				print(get_parent().get_name())
#				This line returns a bug on multiple pickups of compass, since the node will already have a parent
				get_parent().add_child(weapon_to_drop)
				weapon_to_drop.global_transform = hand.global_transform
				weapon_to_drop.dropped = true
				hand.get_child(0).queue_free()
				print("child added")
			reach.get_collider().queue_free()
			hand.add_child(weapon_to_spawn)
			weapon_to_spawn.rotation = hand.rotation
			print("weapon added to hand")
	
	#if Input.is_action_just_pressed("Drop"):
		#if weapon_to_drop != null:
			#if hand.get_child_count() > 0 and hand.get_child(0) != null:
				#get_parent().remove_child(weapon_to_drop)
				#get_parent().add_child(weapon_to_spawn)
				#
				#pass
				
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if void_position > self.get_global_position().y:
		self.set_global_position(reset_position)
		velocity = Vector3.ZERO

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#print( self.get_global_position().x, self.get_global_position().y, self.get_global_position().z )
# DONE: Get Compass Wokring
# DONE: Get neck movement working
# TODO: Put FPS view on seperate layer, attached to camera?
# TODO: Make different points for compass to point to
# DONE: Make Compass into its own object seperate from the player.
# DONE: Make Compass pick-up-able
# TODO: Make Compass droppable via key
# TODO: Add highlight to compass and other pickups
# TODO: Make Compass visuals more dynamic
#		DONE: Compass needle now has some fuzz to it.
		#TODO: Make compass wobble a little bit via animation player
# TODO: Add in pistol weapon
# DONE: Add in telescope
# TODO: Make Spyglass function like a telescope
# DONE: Import Ship
# DONE: Impport Ship's Textures
# DONE: Make Ship into a Floating Body
# TODO: Make Ship into activateable vehicle
# DONE: Make Ship Moveable
# DONE: Make Ship rotate.
# DONE: Get water working
# TODO: Get waves shader working
# TODO: Make Islands as obstacles
# TODO: Make Procedural Targets to Sail to.
# TODO: Add in dogs for passengers to sail
# TODO: Make compass work like a north facing compass.
# TODO: 
