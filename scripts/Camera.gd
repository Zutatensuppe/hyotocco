extends Spatial

var camrot_h = 0
var camrot_v = 0

var cam_v_min = -55
var cam_v_max = 75

var h_sensitivity = 0.1
var v_sensitivity = 0.1

var DEFAULT_HV_ACCELERATION = 10

var h_acceleration = DEFAULT_HV_ACCELERATION
var v_acceleration = DEFAULT_HV_ACCELERATION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera.add_exception(get_parent())

func _input(event) -> void:
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += -event.relative.y * v_sensitivity

func _physics_process(delta: float) -> void:
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)

func set_aiming() -> void:
	var factor = 1 / Engine.time_scale
	h_acceleration = DEFAULT_HV_ACCELERATION * factor
	v_acceleration = DEFAULT_HV_ACCELERATION * factor

func update_fov(fov: int, weight) -> void:
	$h/v/Camera.fov = lerp($h/v/Camera.fov, fov, weight)
