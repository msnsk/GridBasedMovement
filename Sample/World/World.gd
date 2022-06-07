extends Node2D

const ghost_scn = preload("res://Ghost/Ghost.tscn")

var life = 10
var score = 0

onready var player = $Player
onready var tombs = $Tombs
onready var spawn_timer = $SpawnTimer
onready var hud = $UI/HUD
onready var spawn_audio = $SpawnAudio
onready var die_audio = $DieAudio


func _ready():
	randomize()
	player.set_process_unhandled_input(false)
	hud.update_life(life)
	hud.connect("game_started", self, "_on_StartScreen_game_started")


func _on_StartScreen_game_started():
	player.set_process_unhandled_input(true)
	spawn_ghost()
	spawn_timer.start()


func _on_SpawnTimer_timeout():
	spawn_ghost()
	if spawn_timer.wait_time > 1:
		spawn_timer.wait_time -= 0.02


func spawn_ghost():
	var ghost = ghost_scn.instance()
	var tomb_num = randi() % tombs.get_child_count()
	var tomb = tombs.get_child(tomb_num)
	ghost.position = tomb.position
	add_child(ghost)
	ghost.connect("cursed", self, "_on_Ghost_cursed")
	ghost.connect("freed", self, "_on_Ghost_freed")
	spawn_audio.play()


func _on_Ghost_cursed():
	life -= 1
	hud.update_life(life)
	if life == 0:
		spawn_timer.stop()
		player.set_process_unhandled_input(false)
		player.anim_player.play("die")
		die_audio.play()
		yield(player.anim_player, "animation_finished")
		hud.game_over()


func _on_Ghost_freed():
	score += 1
	hud.update_score(score)
