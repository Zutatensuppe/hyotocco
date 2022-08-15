extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var totalTargets = 0
var timeElapsed = 0

var highscore = [0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	var allTargets = get_tree().get_nodes_in_group("targets")
	totalTargets = allTargets.size()
	update_target_count()
	timeElapsed = 0

func _process(delta):
	timeElapsed += delta
	$timeElapsedLabel.text = str(timeElapsed)

func update_target_count():
	var targetsLeft = get_tree().get_nodes_in_group("targets").size()
	$TargetsLabel.text = str(totalTargets-targetsLeft) + "/" + str(totalTargets)

func calculate_score(time_elapsed, targets_hit):
	return max(1, targets_hit * 23 - sqrt(time_elapsed))


func sortDescending(a, b):
	return a > b
		
func reached_goal():
	var targetsLeft = get_tree().get_nodes_in_group("targets").size()
	var targetsHit = totalTargets-targetsLeft
	var score = calculate_score(timeElapsed, targetsHit)
	highscore.append(score)
	highscore.sort_custom(self, "sortDescending")
	highscore = highscore.slice(0, 2)
	var highscoreStrings = []
	for item in highscore:
		if item == 0:
			highscoreStrings.append("-")
		else: 
			highscoreStrings.append(str(item))
	
	$endMenu.setScore(score)
	$endMenu.setHighscore(PoolStringArray(highscoreStrings).join("\n"))
	
	$endMenu.setTimeElapsed(timeElapsed)
	$endMenu.setTargetsHit(str(targetsHit) + "/" + str(totalTargets))
	
	$endMenu.show()
	$player.set_stuck()
