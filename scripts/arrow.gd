extends Spatial

export var muzzle_velocity = 50
export var g = Vector3.DOWN * 8.51

var velocity = Vector3.ZERO
var gravity_vec = Vector3()
var stuck = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("arrows")
	pass # Replace with function body.

func _physics_process(delta):
	if stuck: 
		return
	
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
		stuck = true
		transform.origin = collision.position
	else:
		transform.origin = new_pos


func _on_RigidBody_body_entered(body):
	if body.is_in_group("players"):
		return
	if body.is_in_group("targets"):
		body.got_hit()
	stuck = true
