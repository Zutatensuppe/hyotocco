extends Node

var highscore = [0, 0, 0]

func sortDescending(a, b):
	return a > b
		
func add_score_to_highscore(score):
	highscore.append(score)
	highscore.sort_custom(self, "sortDescending")
	highscore = highscore.slice(0, 2)
