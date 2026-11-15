extends Area3D
class_name Cube
var taken := false
var scalefactor := 1.

func _ready() -> void:
	$MeshInstance3D.rotation += Vector3.ONE * randf() * TAU

func _process(delta: float) -> void:
	$MeshInstance3D.rotation += Vector3.ONE * delta
	if not taken and overlaps_body(Global.player):
		taken = true
		Global.player.velocity = (Global.player.position - position).normalized() * 48
		Global.world.score += 1
	if taken:
		scalefactor = max(0, scalefactor - delta * 4)
	scale = Vector3.ONE * scalefactor
