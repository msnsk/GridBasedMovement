extends KinematicBody2D

signal cursed
signal freed

const particles_scn = preload("res://Ghost/Particles.tscn")

var grid_size = 16

onready var collision = $CollisionShape2D
onready var timer = $Timer
onready var anim_player = $AnimationPlayer
onready var spawn_audio = $SpawnAudio
onready var curse_audio = $CurseAudio


func _ready():
	anim_player.play("spawn")
	spawn_audio.play()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "free":
		timer.stop()
		free_ghost()
		emit_signal("freed")


func free_ghost():
	var particles = particles_scn.instance()
	particles.position = global_position + Vector2(8, 8)
	get_parent().add_child(particles)
	particles.emitting = true


func _on_Timer_timeout():
	collision.disabled = true
	anim_player.play("curse")
	curse_audio.play()
	emit_signal("cursed")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		timer.start()
	elif anim_name == "curse" or anim_name == "free":
		queue_free()




