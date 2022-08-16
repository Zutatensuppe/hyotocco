extends Spatial

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("players"):
		get_tree().get_current_scene().reached_goal()
