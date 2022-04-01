tool
extends EditorScenePostImport

var slide_material = load("res://Resources/slide_material.tres")

func post_import(scene):
	var children = scene.get_children()
	for i in children:
		var args = i.name.split("%",true)
		for y in args:
			if y.findn("rot") != -1:
				print(args)
				var args2 = y.split("#",true)
				if args2.size() >= 2:
					print("Setting rotating obj")
					i.script = load("res://Scripts/Rotate.gd")
					print(args2)
					i.rot_factor = int(args2[2])
					if args2[1] == "x":
						i.rot_dir = 0
					if args2[1] == "y":
						i.rot_dir = 1
					if args2[1] == "z":
						i.rot_dir = 2
				else:
					print("Rot args too small")
			if y.findn("mov") != -1:
				print(args)
				var args2 = y.split("#",true)
				if args2.size() >= 3:
					print("Setting moving object")
					i.script = load("res://Scripts/Move.gd")
					print(args2) # Blender:  X        Y        Z
					i.motion = Vector3(args2[1],args2[3],args2[2])
				else:
					print("Mov args too small")
			if y.findn("smth") != -1:
				var body = i.get_child(0)
				body.physics_material_override = slide_material
	return scene
