extends Control

func setScore(score):
	$Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/scoreValue.text = str(score)

func setTimeElapsed(timeElapsed):
	$Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/timeValue.text = str(timeElapsed)

func setTargetsHit(targetsHit):
	$Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/targetsHitValue.text = str(targetsHit)

func setHighscore(highscore):
	$Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer2/GridContainer2/highscoreValue.text = highscore
