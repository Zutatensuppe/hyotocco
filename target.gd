extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitMesh.hide()
	$UnhitMesh.show()
	add_to_group("targets")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func got_hit():
	$HitMesh.show()
	$UnhitMesh.hide()
	get_parent().update_target_count()
