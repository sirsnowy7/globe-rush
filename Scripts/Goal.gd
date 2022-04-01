extends Spatial

export var rot_factor = 45
onready var player = $"/root/Spatial/Player"
onready var area = $Area
var achieved = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	rotation_degrees.y += rot_factor*delta
	if area.overlaps_body(player) && achieved == false:
		achieved = true
		player.goal = true
