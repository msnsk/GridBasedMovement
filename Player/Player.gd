extends CharacterBody2D


const inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

var grid_size = 16

@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _unhandled_input(event):
	for action in inputs.keys():
		if event.is_action_pressed(action):
			move(action)


func move(action):
	var destination = inputs[action] * grid_size
	ray_cast_2d.target_position = destination
	ray_cast_2d.force_raycast_update()
	if not ray_cast_2d.is_colliding():
		position += destination
