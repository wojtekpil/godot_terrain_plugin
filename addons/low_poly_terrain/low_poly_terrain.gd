tool
extends EditorPlugin


const LOWPOLY_TERRAIN_HEIGHMAP = preload("res://addons/low_poly_terrain/low_poly_terrain_heightmap.gd")
const LOWPOLY_TERRAIN_PROCEDURAL = preload("res://addons/low_poly_terrain/low_poly_terrain_procedural.gd")


static func get_icon(name):
	return load("res://addons/low_poly_terrain/%s.png" % name)

func _enter_tree():
	print("Lowpoly terrain plugin Enter tree")
	add_custom_type("LowpolyTerrainHeighmap", "MeshInstance", LOWPOLY_TERRAIN_HEIGHMAP, get_icon("icon"))
	add_custom_type("LowpolyTerrainProcedural", "MeshInstance", LOWPOLY_TERRAIN_PROCEDURAL, get_icon("icon"))
    # Initialization of the plugin goes here

func _exit_tree():
	print("Lowpoly terrain plugin Exit tree")
	remove_custom_type("LowpolyTerrainHeighmap")
	remove_custom_type("LowpolyTerrainProcedural")
