extends AudioStreamPlayer

var on := true

var click = load("res://Resources/Sound/Menu/Late.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = click
	volume_db = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_click():
	if not stream == click:
		stream = click
	play()
