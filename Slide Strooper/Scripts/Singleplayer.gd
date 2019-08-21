extends Node2D

var skor 			= 0
var detik 			= 5
var milidetik 		= 0
var detikdefault 	= 5
var jawaban 		: bool
var soalterakhir 	: String
onready var pewaktubg 		= $Timerbg
onready var soal 			= $Screen/Soal
onready var scoring 		= $Screen/Scoring
onready var salah 			= $Screen/XY/Wrong
onready var benar 			= $Screen/XY/Correct
onready var labelpewaktu 	= $Screen/CDMargin/Countdown
onready var pewaktu 		= $Screen/CDMargin/Countdown/Timer

func _ready():
	pewaktubg.connect("timeout", globals, "acakbg")
	benar.connect("pressed", self, "cekjawaban")
	salah.connect("pressed", self, "cekjawaban")
	pewaktu.start()
	buatsoal()

# warning-ignore:unused_argument
func _process(delta):
	if milidetik > 9:
		detik -= 1
		milidetik = 0

	if detik == 0:
		detik = detikdefault
		globals.goto_scene("res://Scene/Gameover.tscn")

	labelpewaktu.set_text(str(detik))

func checkpoint():
	if skor > 9 and skor < 25:
		detikdefault = 3
	elif skor > 24 and skor < 50:
		globals.acakbg()
	elif skor > 49 and skor < 500:
		globals.acakbg()
		pewaktubg.start()
	elif skor > 499:
		detikdefault = 2
		globals.acakbg()
		pewaktubg.start()
	elif skor == 1000:
		globals.goto_scene("res://Scene/Gameoverscreen.tscn")

func buatsoal():
	checkpoint()
	detik = detikdefault
	milidetik = 0
	randomize()
	jawaban = bool(globals.benarsalah())
	if jawaban == true:
		buatsoalbenar()
	else:
		buatsoalsalah()

func buatsoalbenar():
	var acakbenar = globals.angkaacak()
	if soalterakhir == str(acakbenar, acakbenar):
		buatsoalbenar()
	else:
		jawaban = true
		soal.set_text(globals.soal.keys()[acakbenar])
		soal.add_color_override("font_color", ColorN(globals.soal.values()[acakbenar]))
		soalterakhir = str(acakbenar, acakbenar)

func buatsoalsalah():
	var namaacak = globals.angkaacak()
	var warnaacak = globals.angkaacak()
	if soalterakhir == str(namaacak, warnaacak):
		buatsoalsalah()
	elif namaacak == warnaacak:
		randomize()
		buatsoalsalah()
	else:
		jawaban = false
		soal.set_text(globals.soal.keys()[namaacak])
		soal.add_color_override("font_color", ColorN(globals.soal.values()[warnaacak]))
		soalterakhir = str(namaacak, warnaacak)

func cekjawaban():
	if benar.pressed and jawaban == true or salah.pressed and jawaban == false:
		skor += 1
		scoring.set_text(str("Score: \n", skor))
		buatsoal()
	else:
		globals.goto_scene("res://Scene/Gameover.tscn")

func _on_Correct_pressed():
	pass

func _on_Wrong_pressed():
	pass

func _on_Back_pressed():
	globals.goto_scene("res://Scene/MainMenu.tscn")

func _on_Timer_timeout():
	milidetik += 1