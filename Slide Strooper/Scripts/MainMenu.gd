extends Node2D

var tekstampil 			= 0
var mode				= 1
onready var help 		= $MenuContainer/Help
onready var credit 		= $MenuContainer/Credit
onready var timer 		= $MenuContainer/Credit/Timer
onready var tekscredit 	= $MenuContainer/Credit/Text

func _ready():
	globals.acakbg()

# warning-ignore:unused_argument
func _process(delta):
	if tekstampil >= 0 and tekstampil < globals.credit.size():
		tekscredit.set_text(str(
		globals.credit.keys()[tekstampil],
		"\n\n",globals.credit.values()[tekstampil],
		"\n\nPage ",tekstampil + 1," of ", globals.credit.size()))
	else:
		tekstampil = 0

func _on_Play_pressed():
	if mode == 1:
		globals.goto_scene("res://Scene/Single.tscn")
	else:
		globals.goto_scene("res://Scene/Multiplayer.tscn")
	globals.acakbg()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Credit_toggled(button_pressed):
	if button_pressed:
		timer.start()
		credit.show()
		#help.hide()
	else:
		tekstampil = 0
		timer.stop()
		credit.hide()

func _on_Help_toggled(button_pressed):
	if button_pressed:
		help.show()
		#credit.hide()
	else:
		help.hide()

func _on_Timer_timeout():
	tekstampil += 1

func _on_Mode_toggled(button_pressed):
	if button_pressed:
		mode = 2
	else:
		mode = 1
	pass