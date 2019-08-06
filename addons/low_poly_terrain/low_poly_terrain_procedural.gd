tool
extends MeshInstance

var TerrainSize = Vector2(4, 4)
var TerrainDetail = 4
var TerrainMaxHeight = 5
var TerrainNoise = Vector2(30, 5)

func _ready():
	generate()
	
func generate():
	var noise = OpenSimplexNoise.new()
	noise.period = TerrainNoise.x
	noise.octaves = TerrainNoise.y
	
	var terrain = PlaneMesh.new()
	terrain.size = TerrainSize
	terrain.subdivide_depth = TerrainSize.y/TerrainDetail
	terrain.subdivide_width = TerrainSize.x/TerrainDetail
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(terrain, 0)
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane,0)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x,vertex.y, vertex.z) * TerrainMaxHeight
		data_tool.set_vertex(i, vertex)
		
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	var mat = get_surface_material(0)
	mesh = surface_tool.commit()
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
	if property == "Terrain/Noise":
		return TerrainNoise

func _set(property, value):
	print("Property name %s" % property)
	if property == "Terrain/Dimmensions":
		TerrainSize = value
	if property == "Terrain/DetailSize":
		TerrainDetail = value
	if property == "Terrain/MaxHeight":
		TerrainMaxHeight = value
	if property == "Terrain/Noise":
		TerrainNoise = value
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
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Terrain/Noise",
			"type": TYPE_VECTOR2
		},
	]
