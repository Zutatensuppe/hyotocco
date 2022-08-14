extends Spatial

export var muzzle_velocity = 50
export var g = Vector3.DOWN * 8.51


var realMeshScale = 0.01
var meshScaleInFlight = 0.05
var velocity = Vector3.ZERO
var gravity_vec = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mesh.scale.x = meshScaleInFlight
	$Mesh.scale.y = meshScaleInFlight
	$Mesh.scale.z = meshScaleInFlight
	add_to_group("arrows")

func _physics_process(delta):
	var old_pos = transform.origin
	velocity += g * delta
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	var new_pos = transform.origin + velocity * delta
	
	var collision = get_world().direct_space_state.intersect_ray(
		old_pos,
		new_pos,
		[self],
		0b11
	)
	
	# check if the arrow collided with something
	# if yes (and its not a player) then set the position to the collision
	# otherwise just set newpos
	if not collision.empty() and not collision.collider.is_in_group("players"):
		if collision.collider.is_in_group("targets"):
			collision.collider.got_hit()
		elif collision.collider.is_in_group("hooktargets"):
			collision.collider.being_hooked()
			get_tree().get_current_scene().get_node('player').hook_towards(collision.collider)
			
		set_stuck()
		transform.origin = collision.position
	else:
		transform.origin = new_pos

func set_stuck():
	set_physics_process(false)
	$Mesh.scale.x = realMeshScale
	$Mesh.scale.y = realMeshScale
	$Mesh.scale.z = realMeshScale
