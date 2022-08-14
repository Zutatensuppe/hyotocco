extends Spatial

func _ready():
	not_being_hooked()
	add_to_group("hooktargets")

func being_hooked():
	$HitMesh.show()
	$UnhitMesh.hide()

func not_being_hooked():
	$HitMesh.hide()
	$UnhitMesh.show()
