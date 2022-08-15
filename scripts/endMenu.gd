extends Control

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().paused = true
		get_tree().change_scene("res://scenes/main.tscn")
		get_tree().paused = false
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func setScore(score):
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/scoreValue.text = str(score)

func setTimeElapsed(timeElapsed):
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/timeValue.text = str(timeElapsed)

func setTargetsHit(targetsHit):
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/targetsHitValue.text = str(targetsHit)

func setHighscore(highscore):
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer2/GridContainer2/highscoreValue.text = highscore
