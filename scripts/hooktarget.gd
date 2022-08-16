extends Spatial

func _ready() -> void:
	not_being_hooked()
	add_to_group("hooktargets")

func being_hooked() -> void:
	$HitMesh.show()
	$UnhitMesh.hide()

func not_being_hooked() -> void:
	$HitMesh.hide()
	$UnhitMesh.show()
