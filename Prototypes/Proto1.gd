extends Spatial

onready var character = $RigidBody
onready var remoteTransform = $RigidBody/RemoteTransform
onready var cameraBase = $Spatial
onready var camera = $Spatial/Camera
onready var level = $Level
onready var label = $Label
onready var label2 = $Label2

var vect := Vector2()

export var cam_interpol = 1/10

func _ready():
	remoteTransform.remote_path = cameraBase.get_path()

func _process(delta):
	
	# === Input ===
	
	vect.x = Input.get_axis("axis0-", "axis0+")
	vect.y = Input.get_axis("axis1-", "axis1+")
	
	# === Level origin movement ===
	
	var charOrigin = character.transform.origin
	charOrigin.y = 0 # gets player position, changes y to 0
	
	level.transform.origin = charOrigin
	level.get_child(0).transform.origin = -charOrigin
	# offset level origin with level.child origin as negative
	
	# === Rotate camera/input ===
	
	if character.linear_velocity.length() > 2:
		cameraBase.rotation.y = Vector2(character.linear_velocity.x, character.linear_velocity.z).angle()
		
		cameraBase.rotation.y = -cameraBase.rotation.y-PI/2
		
		label.text = str(vect)
		label2.text = str(vect.rotated(-cameraBase.rotation.y-PI/2))
