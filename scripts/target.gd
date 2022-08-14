extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitMesh.hide()
	$UnhitMesh.show()
	add_to_group("targets")
	pass # Replace with function body.


func got_hit():
	$HitMesh.show()
	$UnhitMesh.hide()
	remove_from_group("targets")
	get_tree().get_current_scene().update_target_count()
