extends Spatial

func _ready():
	$HitMesh.hide()
	$UnhitMesh.show()
	add_to_group("targets")

func got_hit():
	$HitMesh.show()
	$UnhitMesh.hide()
	remove_from_group("targets")
	get_tree().get_current_scene().update_target_count()
