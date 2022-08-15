extends Spatial

func _ready():
	pass



func _on_Area_body_entered(body):
	if body.is_in_group("players"):
		get_tree().get_current_scene().reached_goal()
