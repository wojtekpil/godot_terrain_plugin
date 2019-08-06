tool
extends MeshInstance

var TerrainSize = Vector2(4, 4)
var TerrainDetail = 4
var TerrainMaxHeight = 5
var TerrainHeightmap = null

func _ready():
	generate()

#display an empty plane with material in case of no heighmap
func generate_stub_plane():
	var terrain = PlaneMesh.new()
	terrain.size = TerrainSize
	var mat = get_surface_material(0)
	mesh = terrain
	set_surface_material(0, mat)

func generate():
	if TerrainHeightmap == null:
		generate_stub_plane()
		return
	var image = TerrainHeightmap.get_data()
	var min_mage_size = min(image.get_width(), image.get_height()) - 1
	var max_terrain_size = max(TerrainSize.y, TerrainSize.x);
	var scale = min_mage_size/max_terrain_size
	
	var terrain = PlaneMesh.new()
	terrain.size = TerrainSize
	terrain.subdivide_depth = TerrainSize.y/TerrainDetail
	terrain.subdivide_width = TerrainSize.x/TerrainDetail
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(terrain, 0)
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane,0)
	
	image.lock()
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = image.get_pixel((vertex.x + TerrainSize.x / 2)*scale , (vertex.z + TerrainSize.y / 2)*scale).r * TerrainMaxHeight
		data_tool.set_vertex(i, vertex)
	image.unlock()
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	var mat = get_surface_material(0)
	mesh = surface_tool.commit()
	if mat != null:
		set_surface_material(0, mat)

func _process(delta):
	pass
	


func _get(property):
	if property == "Terrain/Dimmensions":
		return TerrainSize
	if property == "Terrain/DetailSize":
		return TerrainDetail
	if property == "Terrain/MaxHeight":
		return TerrainMaxHeight
	if property == "Terrain/HeightMap":
		return TerrainHeightmap

func _set(property, value):
	print("Property name %s" % property)
	if property == "Terrain/Dimmensions":
		TerrainSize = value
	if property == "Terrain/DetailSize":
		TerrainDetail = value
	if property == "Terrain/MaxHeight":
		TerrainMaxHeight = value
	if property == "Terrain/HeightMap":
		TerrainHeightmap = value
	generate()

func _get_property_list():
	return [
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Terrain/Dimmensions",
			"type": TYPE_VECTOR2
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Terrain/DetailSize",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Terrain/MaxHeight",
			"type": TYPE_REAL
		},
		{
			"name": "Terrain/HeightMap",
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "Texture"
		},
	]
