extends Spatial

export var motion = Vector3(0,0,0) # Move vector (will be doubled
export var offset = Vector3(0,0,0) # Change start point
export var move_v = 0.05 # How fast (per frame?)
export var type = 0 # 1 for LERP

var snap_vect = Vector3(0.2,0.2,0.2)

var end1 := Vector3()
var end2 := Vector3()
var mode := true

func _ready():
	end1 = translation + motion
	end2 = translation - motion
	translation += offset

func _process(delta):
	if type == 1:
		move_lerp()
	else:
		move_linear()


func move_linear():
	if mode:
		translation = translation.move_toward(end1, move_v)
		if translation == end1:
			mode = false
	else:
		translation = translation.move_toward(end2, move_v)
		if translation == end2:
			mode = true

func move_lerp():
	if mode:
		translation = lerp(translation, end1, move_v)
		if translation.snapped(snap_vect) == end1:
			mode = false
	else:
		translation = lerp(translation, end2, move_v)
		if translation.snapped(snap_vect) == end2:
			mode = true
