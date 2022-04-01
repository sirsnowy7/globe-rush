extends Area

onready var player = $"/root/Spatial/Player"
onready var activeMarker = $checkpoint_active

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if overlaps_body(player):
		Stats.checkpoint = get_index()
		for sibling in get_parent().get_children():
			sibling.activeMarker.visible = false
		if get_index() > 0:
			activeMarker.visible = true
