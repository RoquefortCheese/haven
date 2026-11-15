extends CharacterBody3D
class_name Player

var panning: Vector2
var dashed := true
var dashleft := 0.
var dashdir: Vector3

func _process(delta: float) -> void:
	if not Global.world.finished:
		movementinput(delta)
		pancamera(delta)

const sensitivity := 0.005
const acc := 2 ** 7.5
const friction := 2 ** -20.
const gravity := 25.
const jumpspeed := 20.
const dashspeed := 32.
const dashtime := 0.6

func _ready() -> void:
	Global.player = self

func movementinput(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var direction := Vector2.ZERO
		if Input.is_action_pressed("forward"):
			direction += Vector2.UP
		if Input.is_action_pressed("back"):
			direction += Vector2.DOWN
		if Input.is_action_pressed("left"):
			direction += Vector2.LEFT
		if Input.is_action_pressed("right"):
			direction += Vector2.RIGHT
		direction = direction.normalized().rotated(-($Camera3D as Node3D).rotation.y)
		velocity += Vector3(direction.x, 0, direction.y) * acc * delta
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = jumpspeed
		if Input.is_action_pressed("dash"):
			if not dashed:
				dashleft = dashtime
				dashdir = $Camera3D/CamDir.global_position - $Camera3D.global_position
				dashed = true

func pancamera(delta: float) -> void:
	for axis in 2:
		var correction := 1 - 2 ** (delta * -32)
		var spin := (panning[axis] - ($Camera3D as Node3D).rotation[1 - axis]) * correction
		$Camera3D.rotation[1 - axis] += spin
		panning[axis] -= spin
	$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI / 2, PI / 2)

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	for axis in [0, 2]:
		velocity[axis] *= friction ** delta
	var prevvel := velocity
	move_and_slide()
	if velocity.y == 0 and prevvel.y <= -4 and Input.is_action_pressed("dash"):
		velocity.y = -prevvel.y
		move_and_slide()
	if is_on_floor():
		dashed = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("focus"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			panning += -event.relative * sensitivity
