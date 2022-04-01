extends Spatial

export var rot_factor = 10
export var rot_dir = 1

func _ready():
	pass

func _process(delta):
	if rot_dir == 0:
		rotation_degrees.x += rot_factor*delta
	elif rot_dir == 1:
		rotation_degrees.y += rot_factor*delta
	elif rot_dir == 2:
		rotation_degrees.z += rot_factor*delta
