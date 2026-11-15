extends Node3D
class_name Terrain

const cardinals: Array[Vector3] = [Vector3.UP, Vector3.DOWN, Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3.BACK]
const bases: Dictionary[Vector3, Basis] = {
	Vector3.UP: Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK),
	Vector3.DOWN: Basis(Vector3.LEFT, Vector3.DOWN, Vector3.BACK),
	Vector3.RIGHT: Basis(Vector3.FORWARD, Vector3.RIGHT, Vector3.DOWN),
	Vector3.LEFT: Basis(Vector3.BACK, Vector3.LEFT, Vector3.DOWN),
	Vector3.FORWARD: Basis(Vector3.LEFT, Vector3.FORWARD, Vector3.DOWN),
	Vector3.BACK: Basis(Vector3.RIGHT, Vector3.BACK, Vector3.DOWN)
}
@export var face: PlaneMesh

const sidelen := 16  # 48
const chunkquant := 1  # 8
const cubequant := 16
const thresh := -0.25
@export var noise: FastNoiseLite
@export var material: Material

# only two block types, so using bools for simplicity
var voxmap: Dictionary[Vector3, bool]
var chunkmap: Dictionary[Vector3, bool]
var openvox: Array[Vector3]

func placerandom() -> Vector3:
	return openvox.pick_random() + Vector3.ONE * 0.5

func generate() -> void:
	setup()
	genchunks()
	genvox()
	genmeshes()
	placecubes()

func setup() -> void:
	pass

func genchunks() -> void:
	var potato := Vector3.ZERO
	var dug := 0
	while dug != chunkquant:
		if potato not in chunkmap:
			chunkmap[potato] = true
			dug += 1
		potato += cardinals.pick_random()

func genvox() -> void:
	noise.seed = randi()
	for chunk in chunkmap:
		for x in sidelen:
			for y in sidelen:
				for z in sidelen:
					var point := Vector3(x, y, z)
					point += chunk * sidelen
					var solid := noise.get_noise_3dv(point) <= thresh
					voxmap[point] = solid
					if not solid:
						openvox.append(point)

func genmeshes() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for vox in voxmap:
		if not voxmap[vox]:
			for cardinal in cardinals:
				var point := vox + cardinal
				if point not in voxmap or voxmap[point]:
					var org := vox + Vector3.ONE * 0.5 + cardinal * 0.5
					var bss := bases[cardinal]
					st.append_from(face, 0, Transform3D(bss, org))
	st.set_material(material)
	$MeshInstance3D.mesh = st.commit()
	$MeshInstance3D.create_trimesh_collision()

func placecubes() -> void:
	for icube in cubequant:
		var cube: Cube = load("res://cube.tscn").instantiate()
		$Cubes.add_child(cube)
		cube.position = placerandom()
