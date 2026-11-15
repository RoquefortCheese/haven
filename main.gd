extends Node
class_name Main

func newworld() -> void:
	Global.world = load("res://world.tscn").instantiate()
	add_child(Global.world)
	await Global.world.generate()

func _ready() -> void:
	Global.main = self
	await newworld()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("restart"):
		remove_child(Global.world)
		await newworld()
