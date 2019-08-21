extends Control

func _ready():
	$Winner.set_text(str("Player ", globals.winner))
	pass

func _on_Mainmenu_pressed():
	globals.goto_scene("res://Scene/MainMenu.tscn")
