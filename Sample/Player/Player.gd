extends KinematicBody2D

const inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

var grid_size = 16

onready var raycast = $RayCast2D
onready var ring = $Ring
onready var anim_player = $AnimationPlayer
onready var step_audio = $StepAudio
onready var ring_audio = $RingAudio


func _ready():
	ring.hide()


func _unhandled_input(event):
	for action in inputs.keys():
		if event.is_action_pressed(action):
			move(action)
	if event.is_action_pressed("ring"):
		raise_ring()


func move(action):
	var destination = inputs[action] * grid_size
	raycast.cast_to = destination
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		position += destination
		step_audio.play()


func raise_ring():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Ghost"):
			var ghost_anim = collider.anim_player.current_animation
			if ghost_anim != "free" and ghost_anim != "curse":
				anim_player.play("ring")
				ring_audio.play()
				collider.anim_player.play("free")

