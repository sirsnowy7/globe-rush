extends Spatial

var vect := Vector2()

onready var camBase = get_parent().get_node("Spatial")

export var tilt_scale = 20

func _ready():
	pass

func _process(delta):
	vect.x = Input.get_axis("axis0-", "axis0+")
	vect.y = Input.get_axis("axis1-", "axis1+")
	
	vect = vect.rotated(-camBase.rotation.y-PI/2)
	
	rotation_degrees = Vector3(vect.x * tilt_scale, 0, vect.y * tilt_scale).linear_interpolate(rotation_degrees, 0.8)
