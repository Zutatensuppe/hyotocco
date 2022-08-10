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
	
	velocity += g * delta
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta


func _on_arrow_area_body_entered(body):
	if body.is_in_group("players"):
		pass
	else:
		stuck = true



func _on_Area_area_entered(area):
	if area.name == 'target_area':
		area.get_parent().got_hit()
		stuck = true
