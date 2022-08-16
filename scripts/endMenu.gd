extends Control

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		get_tree().paused = true
		get_tree().change_scene("res://scenes/main.tscn")
		get_tree().paused = false
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func setScore(score: float) -> void:
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/scoreValue.text = str(score)

func setTimeElapsed(timeElapsed: float) -> void:
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/timeValue.text = str(timeElapsed)

func setTargetsHit(targetsHit: String) -> void:
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer/GridContainer/targetsHitValue.text = targetsHit

func setHighscore(highscore: String) -> void:
	$MarginContainer/Control/HBoxContainer2/VBoxContainer/HBoxContainer/MarginContainer2/GridContainer2/highscoreValue.text = highscore
