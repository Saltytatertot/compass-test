@tool

extends Node3D

var OceanTile = preload("res://Scenes/water_plane.tscn")
var spawnPoint = preload("res://Resources/GridSpawnInfo.tres")

func createOceanTiles():
	for i in 17:
		
		var spawnLocation = spawnPoint.spawnPoints[i]
		var tileSubdivision = spawnPoint.subdivision[i]
		var tileScale = spawnPoint.scale[i]
		var instance = OceanTile.instantiate();
		
		add_child(instance)
		
		instance.position = Vector3(spawnLocation.x, 0.0, spawnLocation.y) * 10.05
		instance.mesh.set_subdivide_width(tileSubdivision)
		instance.mesh.set_subdivide_depth(tileSubdivision)
		instance.set_scale(Vector3(tileScale, 1.0, tileScale))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createOceanTiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("OCEAN_POSITION", self.position)
