extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var arrow
export (NodePath) var animationtree

onready var _anim_tree = get_node(animationtree)

var FOV_NORMAL: float = 70
var FOV_AIMING: float = 30

var MAX_AIM_TIME_SEC: float = .8
var SHOOT_TIMEOUT_SEC: float = .3

var gravity = 20
var movement_speed = 10
var jump = 10
var pull_speed = 50

var gravity_vec = Vector3()

var angular_accel: int = 7
var fov_accel: int = 20

var need_release: bool = false
var hooking_towards = null

func _ready() -> void:
	add_to_group("players")

func shoot_arrow(timeAimed: float) -> void:
	var shoot_origin = $shootFrom.global_transform.origin
	var mouse_position = get_tree().root.get_mouse_position()
	var ray_from = $Camroot/h/v/Camera.project_ray_origin(mouse_position)
	var ray_dir = $Camroot/h/v/Camera.project_ray_normal(mouse_position)
	var ray_to = ray_from + ray_dir * 9999
	
	var collision = get_world().direct_space_state.intersect_ray(
		ray_from,
		ray_to,
		[self],
		0b11
	)
	var shoot_target = ray_to if collision.empty() else collision.position
	var shoot_dir = (shoot_target - shoot_origin).normalized()
	
	var b = arrow.instance()
	
	var MIN_VELOCITY = 50
	var MAX_VELOCITY = 110
	var velocity = MIN_VELOCITY + timeAimed * 2 * (MAX_VELOCITY - MIN_VELOCITY)
	
	b.muzzle_velocity = velocity
	
	get_tree().get_current_scene().add_child(b)
	b.global_transform.origin = shoot_origin
	b.look_at(shoot_origin + shoot_dir, Vector3.UP)
	b.global_transform.origin.move_toward(shoot_origin + shoot_dir, 1)
	b.velocity = -b.transform.basis.z * b.muzzle_velocity
	
	$ShootTimer.start(SHOOT_TIMEOUT_SEC)

func start_aiming(delta: float) -> void:
	Engine.time_scale = 0.2
	
	var maxAimTime = MAX_AIM_TIME_SEC * Engine.time_scale
	if $AimTimer.is_stopped():
		$AimTimer.start(maxAimTime)
		
	$crosshairProgress.value = (maxAimTime - $AimTimer.time_left) / maxAimTime * 100
	$Camroot.set_aiming()
	$Camroot.update_fov(FOV_AIMING, delta * fov_accel * 2)

func stop_aiming(delta: float) -> void:
	Engine.time_scale = 1.0
	
	if not $AimTimer.is_stopped():
		$AimTimer.stop()
	$crosshairProgress.value = 0
	$Camroot.set_aiming()
	$Camroot.update_fov(FOV_NORMAL, delta * fov_accel)

func hook_towards(hooktarget) -> void:
	hooking_towards = hooktarget
	
func _physics_process(delta: float) -> void:
	var aiming: bool = false
	var jumping: bool = false 
	var running: bool = false 
	
	if hooking_towards != null:
		# Pull the player towards the hook target location 
		var hook_position: Vector3 = hooking_towards.transform.origin
		var player_position: Vector3 = transform.origin
		var hook_direction: Vector3 = hook_position - player_position
		var velocity: Vector3 = hook_direction.normalized() * pull_speed
		
		var _linear_velocity_vector: Vector3 = move_and_slide(velocity, Vector3.UP)
		var collisionCounter: int = get_slide_count() - 1
		if collisionCounter > -1:
			var col = get_slide_collision(collisionCounter)
			if col.collider.is_in_group("hooktargets"):
				col.collider.not_being_hooked()
				hooking_towards = null
		
	
	if $ShootTimer.time_left == 0 and not need_release:
		# may shoot	
		if Input.is_action_pressed("shoot"):
			start_aiming(delta)
			aiming = true
		elif Input.is_action_just_released("shoot"):
			shoot_arrow(MAX_AIM_TIME_SEC - $AimTimer.time_left)
			need_release = true
	else:
		# may not shoot
		stop_aiming(delta)
	
	if need_release and not Input.is_action_pressed("shoot"):
		need_release = false

	# movement up/down/left/right	
	if not hooking_towards:
		var direction: Vector3
		if (
			Input.is_action_pressed("move_right") ||
			Input.is_action_pressed("move_left") || 
			Input.is_action_pressed("move_forward") || 
			Input.is_action_pressed("move_backward")
			):
			running = true
			var h_rot: float = $Camroot/h.global_transform.basis.get_euler().y
			
			direction = Vector3(
				Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"),
				0,
				Input.get_action_raw_strength("move_backward") - Input.get_action_raw_strength("move_forward")
			).rotated(Vector3.UP, h_rot).normalized()
			
			$archer.rotation.y = lerp_angle($archer.rotation.y, atan2(direction.x, direction.z), delta * angular_accel)
		else:
			direction = Vector3()
		
		if not is_on_floor():
			gravity_vec += Vector3.DOWN * gravity * delta
			jumping = true
		else:
			gravity_vec = -get_floor_normal() * gravity
			
			if Input.is_action_just_pressed("jump") and is_on_floor():
				gravity_vec = Vector3.UP * jump
				jumping = true
		
		var movement: Vector3 = direction * movement_speed
		movement.y = gravity_vec.y
		
		var _linear_velocity_vector: Vector3 = move_and_slide(movement, Vector3.UP)
	
	# set correct animation
	if aiming:
		_anim_tree["parameters/playback"].travel("aim")
	elif jumping:
		_anim_tree["parameters/playback"].travel("jump")
	elif running:
		_anim_tree["parameters/playback"].travel("run")
	else:
		_anim_tree["parameters/playback"].travel("idle")


func _on_AimTimer_timeout() -> void:
	shoot_arrow(MAX_AIM_TIME_SEC)


func _on_ShootTimer_timeout() -> void:
	$ShootTimer.stop()


func set_stuck() -> void:
	$crosshairProgress.hide()
	set_physics_process(false)
