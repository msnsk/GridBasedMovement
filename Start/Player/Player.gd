extends KinematicBody2D

const inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

var grid_size = 16

onready var raycast = $RayCast2D


func _unhandled_input(event):
	for action in inputs.keys():
		if event.is_action_pressed(action):
			move(action)


func move(action):
	var destination = inputs[action] * grid_size
	raycast.cast_to = destination
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		position += destination

