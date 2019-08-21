extends Node

var bgacak 			: int
var bgterakhir 		: int
var current_scene 	= null
# warning-ignore:unused_class_variable
var winner			: int
var warnabg = 	[
				"olive",
				"peru",
				"forestgreen",
				"tan",
				"aqua",
				"coral",
				"indigo",
				"darksalmon",
				"cornflower",
				"cadetblue"
				]
var soal 	= 	{
				"WHITE": "white",
				"RED": "red",
				"YELLOW": "yellow",
				"GREEN": "green",
				"BLUE": "blue",
				"PINK": "hotpink",
				"PURPLE": "darkviolet",
				"BROWN": "saddlebrown",
				"ORANGE": "darkorange",
				"GRAY": "dimgray"
				}
# warning-ignore:unused_class_variable
var credit 	=	{
				"A GAME BY": 
				"Unknown Studio",
				"TEAM": 
				"Amal Alim Maulana\nAditya Septiawan",
				"TESTERS": 
				"Belum Jadi",
				"TOOLS AND ASSETS":
				"Godot Engine\nAseprite",
				"SPECIAL THANKS TO": 
				"You"
				}

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func angkaacak():
	randomize()
	return int(randi() % soal.size())

func benarsalah():
	var xory = [0,1]
	return xory[randi() % xory.size()]

func acakbg():
	bgterakhir = bgacak
	bgacak = angkaacak()
	if bgterakhir == bgacak:
		randomize()
		acakbg()
	else:	
		VisualServer.set_default_clear_color(ColorN((warnabg[bgacak])))	

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)