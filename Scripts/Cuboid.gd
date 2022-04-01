extends Area

onready var player = $"/root/Spatial/Player"

func _ready():
	pass

func _process(delta):
	rotation_degrees.y += 90*delta
	if overlaps_body(player):
		player.score_increase()
		queue_free()
