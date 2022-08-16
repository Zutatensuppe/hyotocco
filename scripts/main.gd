extends Spatial

var totalTargets = 0
var timeElapsed = 0
var state = "game"

func _ready() -> void:
	var allTargets = get_tree().get_nodes_in_group("targets")
	totalTargets = allTargets.size()
	update_target_count()
	timeElapsed = 0

func _process(delta: float) -> void:
	if state == "game":
		timeElapsed += delta
		$hud/timeElapsedLabel.text = str(timeElapsed)

func update_target_count() -> void:
	var targetsLeft = get_tree().get_nodes_in_group("targets").size()
	$hud/targetsLabel.text = str(totalTargets-targetsLeft) + "/" + str(totalTargets)

func calculate_score(time_elapsed: int, targets_hit: int) -> float:
	return max(1, targets_hit * 23 - sqrt(time_elapsed))

func reached_goal() -> void:
	state = "end"
	var targetsLeft: int = get_tree().get_nodes_in_group("targets").size()
	var targetsHit: int = totalTargets-targetsLeft
	var score: float = calculate_score(timeElapsed, targetsHit)
	Globals.add_score_to_highscore(score)
	var highscoreStrings = []
	for item in Globals.highscore:
		if item == 0:
			highscoreStrings.append("-")
		else: 
			highscoreStrings.append(str(item))
	
	$endMenu.setScore(score)
	$endMenu.setHighscore(PoolStringArray(highscoreStrings).join("\n"))
	
	$endMenu.setTimeElapsed(timeElapsed)
	$endMenu.setTargetsHit(str(targetsHit) + "/" + str(totalTargets))
	
	$endMenu.show()
	$hud.hide()
	$player.set_stuck()


