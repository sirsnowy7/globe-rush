extends RigidBody

# exports

export var LEVEL := 1
export var LEVEL_COLOR := Color.white
export var D_HEIGHT := -20
export var D_BUG := false

export var FADE := 0.01

export var force := 15

export var CAM_LERP := 0.04
export var CAM_TILT := 15
export var CAM_TILT_LERP := 0.2
export var CAM_BASE_TILT := -25

# tracking

var analog_tilt := Vector2()

var vect := Vector2()
var current_cam_tilt_x := 0
var current_cam_tilt_z := 0

var score := 0
var time := 0.0

var goal := false
var timeStarted := false

#var velocities := [0,0,0]

# nodes

onready var scoreLabel = $UI/Grid/ScoreBox/HBox/ScoreLabel
onready var timerLabel = $UI/Grid/TimerBox/HBox/TimerLabel
onready var dLabel = $UI/Grid/DBox/HBox/DLabel

onready var analog = $UI/Analog

onready var timer = $"../Timer"
onready var audio = $"AudioPlayer"
onready var tree = get_tree()
onready var checkpoints = get_parent().get_node("Checkpoints")
onready var cameraBase = get_parent().get_node("CameraBase")
onready var camera = get_parent().get_node("CameraBase/Camera")
onready var world_env = get_parent().get_node("WorldEnvironment")
onready var collectibles = get_parent().get_node("Collectibles")

# scenes

var quitModal = load("QuitModal.tscn")

# resources

var collect_sound = preload("res://Resources/Sound/Gameplay/pickup.wav")
var max_sound = preload("res://Resources/Sound/Gameplay/magic.wav")
#var hit1 = preload("res://Resources/Sound/hit1.wav")
#var hit2 = preload("res://Resources/Sound/hit2.wav")

func _ready():
	# change mode
	if Stats.harden:
		force = 16
		mass = 0.7
	
	# set pos to checkpoint
	transform = checkpoints.get_child(Stats.checkpoint).transform
	
	# connect analog
	analog.connect("analog_force_change", self, "_on_analog_change")
	
#	# connect collisions
#	connect("body_entered", self, "_on_collision")
	
	# add time
	if Stats.checkpoint > 0:
		time += Stats.prev_time
	
	# set camera def
	cameraBase.rotation.y = rotation.y
	
	# change sky and env
	var pano := PanoramaSky.new()
	pano.panorama = load("res://HDRI/level_" + str(LEVEL) + ".hdr")
	world_env.environment.background_sky = pano
	world_env.environment.ambient_light_color = LEVEL_COLOR
	world_env.environment.background_energy = 1

func _input(event):
	if event.is_action_pressed("escape"):
		add_child(quitModal.instance())
		get_tree().paused = true
	if event.is_action_pressed("retry"):
		retry(false)

func _process(delta):
	
#	# === Tracking ===
#
#	velocities.push_front(linear_velocity.z())
#	velocities.pop_back()
	
	# === HUD ===
	
	if not goal: # if player hasnt reached goal update time & time label
		time += delta
		timerLabel.text = str(stepify(time, 0.01))
	# update score label
	scoreLabel.text = str(score) + "/" + str(Stats.max_stats[LEVEL-1][1])
	if D_BUG:
		dLabel.text = str(Performance.get_monitor(Performance.TIME_FPS))
	
	# === Goal ===
	
	if goal: # go up when goal reached, fade environment
		add_central_force(Vector3(0,50,0))
		world_env.environment.background_energy -= FADE
	
	# save stats once and start timer once if timer not started
	if goal && timeStarted == false:
		save_stats()
		timeStarted = true
		timer.start()
	
	# === Death ===
	
	if translation.y < D_HEIGHT:
		retry(true)
	
	# === Camera/Movement ===
	
	# == Input ==
	# get gamepad input
	vect.x = Input.get_axis("axis0-", "axis0+")
	vect.y = Input.get_axis("axis1-", "axis1+")
	
	if !analog_tilt.is_equal_approx(Vector2(0,0)):
		vect.x = analog_tilt.x
		vect.y = -analog_tilt.y
	
	# == Camera ==
	# set the camera's origin to player origin
	cameraBase.transform.origin = transform.origin
	
	# == Rotate camera around x/z ==
	
	current_cam_tilt_x = vect.y * -CAM_TILT
	current_cam_tilt_z = vect.x * CAM_TILT
	camera.rotation_degrees.x = lerp(camera.rotation_degrees.x,
		CAM_BASE_TILT + current_cam_tilt_x, CAM_TILT_LERP)
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z,
		current_cam_tilt_z, CAM_TILT_LERP)
	
	# == Rotate camera around y ==
	
	if linear_velocity.length() > 2:
		var velVect2 = Vector2(linear_velocity.x, linear_velocity.z)
		velVect2 = velVect2.reflect(Vector2(1,0)).rotated(-PI/2) * 10 # rel
		velVect2 = velVect2.round() / 10
		cameraBase.rotation.y = lerp_angle(cameraBase.rotation.y, velVect2.angle(), CAM_LERP)
	
	# == Movement ==
	
	vect = vect.rotated(cameraBase.rotation.reflect(Vector3(1,0,0)).y)
	var vect3 = Vector3(vect.x, 0, vect.y)
	
	add_central_force(vect3*force)
	
	# == Rotate world ==
	
	var skyR = Vector3(-camera.rotation_degrees.x+CAM_BASE_TILT, 0, -camera.rotation_degrees.z)
	skyR = skyR.rotated(Vector3(0,1,0), cameraBase.rotation.y)
	skyR = -skyR
	world_env.environment.background_sky_rotation_degrees = skyR

#func _on_collision(body):
#	if velocities[2] > 6 :
#		audio.stream = hit1
#		audio.play()
#	elif velocities[2] > 2 :
#		audio.stream = hit2
#		audio.play()
#	else:
#		pass

func retry(death):
	# set prev. time for adding later
	Stats.prev_time = time
	# if player manually reset and is on level select, reset checkpoint
	if not death and Stats.level_select:
		Stats.checkpoint = 0
	# reset
	get_tree().reload_current_scene()

func quit_to_menu():
	# reset checkpoint and quit
	Stats.checkpoint = 0
	world_env.environment.background_energy = 1
	get_tree().change_scene("MainMenu.tscn")

func save_stats():
	# truncated time float
	time = stepify(time, 0.01)
	# if time is better than previous time || previous time is -1, save
	if time < Stats.level_stats[LEVEL-1][0] or Stats.level_stats[LEVEL-1][0] == -1.0:
		Stats.level_stats[LEVEL-1][0] = stepify(time, 0.01)
	# if score is better than prev. score, save
	if score > Stats.level_stats[LEVEL-1][1]:
		Stats.level_stats[LEVEL-1][1] = score
	Stats.save_to_file()

func score_increase():
	score += 1
	if score >= Stats.max_stats[LEVEL-1][1]:
		audio.stream = max_sound
	else:
		audio.stream = collect_sound
	audio.play()

func _on_analog_change(new_vect, an_name):
	analog_tilt = new_vect

func _on_Timer_timeout():
	# when level ends reset checkpoint
	Stats.checkpoint = 0
	world_env.environment.background_energy = 1
	# and return to level select || move on to next level
	if Stats.level_select:
		tree.change_scene("LevelSelect.tscn")
	elif LEVEL == 3:
		tree.change_scene("MainMenu.tscn")
	else:
		tree.change_scene("Levels/Level_" + str(LEVEL + 1) + ".tscn")
