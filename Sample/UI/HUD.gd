extends Control

signal game_started

var count = 3

onready var back_color = $BackColor
onready var start_scr = $StartScreen
onready var timer = $Timer
onready var count_down = $Countdown
onready var play_scr = $PlayScreen
onready var life_container = $PlayScreen/LifeContainer
onready var score_label = $PlayScreen/ScoreLabel
onready var game_over_scr = $GameOverScreen
onready var final_score_label = $GameOverScreen/FinalScoreLabel
onready var button_audio = $ButtonAudio


func _ready():
	count_down.hide()
	play_scr.hide()
	game_over_scr.hide()


func _on_StartButton_pressed():
	button_audio.play()
	back_color.hide()
	start_scr.hide()
	count_down.show()
	play_scr.show()
	timer.start()


func _on_Timer_timeout():
	count -= 1
	if count > 0:
		count_down.text = str(count)
	elif count == 0:
		count_down.text = "Go!"
	else:
		timer.stop()
		count_down.hide()
		emit_signal("game_started")


func update_life(life: int):
	for i in life_container.get_child_count():
		life_container.get_child(i).visible = life > i


func update_score(score: int):
	score_label.text = "Score: " + str(score)
	final_score_label.text = "Final Score: " + str(score)


func game_over():
	play_scr.hide()
	back_color.show()
	game_over_scr.show()


func _on_QuitButton_pressed():
	button_audio.play()
	yield(button_audio, "finished")
	get_tree().quit()
