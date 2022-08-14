extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var totalTargets = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var allTargets = get_tree().get_nodes_in_group("targets")
	totalTargets = allTargets.size()
	update_target_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_target_count():
	var targetsLeft = get_tree().get_nodes_in_group("targets").size()
	$TargetsLabel.text = str(totalTargets-targetsLeft) + "/" + str(totalTargets)
