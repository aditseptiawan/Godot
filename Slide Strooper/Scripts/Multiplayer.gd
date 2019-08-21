extends Node2D

var skor 			= [0, 0]
var detik 			= 5
var milidetik 		= 0
var detikdefault 	= 5
var waktu			= "X"
var soalterakhir 	: String
var jawaban 		: bool
var hasil			: bool
var player1benar	: bool
var player2benar	: bool
var babak			: int
var acakbg2 		: int
var bgp2terakhir	: int
onready var pewaktu 	= $Pewaktu
onready var pewaktubg 	= $PewaktuBG
onready var soalp1 		= $ScreenP1/SoalP1
onready var soalp2 		= $ScreenP2/SoalP2
onready var salahp1 	= $ScreenP1/P1/WrongP1
onready var salahp2 	= $ScreenP2/P2/WrongP2
onready var benarp1 	= $ScreenP1/P1/CorrectP1
onready var benarp2 	= $ScreenP2/P2/CorrectP2
onready var skorp1		= $ScreenP1/SkorP1
onready var skorp2		= $ScreenP2/SkorP2
onready var time		= $Waktu
onready var bgp2		= $BGP2

func _ready():
	pewaktubg.connect("timeout", globals, "acakbg")
	pewaktubg.connect("timeout", self, "acakbgp2")
	benarp1.connect("pressed", self, "cekjawaban")
	benarp2.connect("pressed", self, "cekjawaban")
	salahp1.connect("pressed", self, "cekjawaban")
	salahp2.connect("pressed", self, "cekjawaban")
	pewaktu.start()
	buatsoal()

func _process(delta):
	if milidetik > 9:
		detik -= 1
		milidetik = 0
		waktu += "X"

	if detik == 0:
		detik = detikdefault
		waktu = "X"
		buatsoal()

	time.set_text(waktu)

func acakbgp2():
	bgp2terakhir = acakbg2
	acakbg2 = globals.angkaacak()
	if acakbg2 == bgp2terakhir:
		randomize()
		acakbgp2()
	bgp2.color = ColorN(globals.warnabg[acakbg2])

func checkpoint():
	if babak > 4 and babak < 10:
		detikdefault = 3
	elif babak > 9 and babak < 15:
		globals.acakbg()
		acakbgp2()
	elif babak > 14:
		globals.acakbg()
		acakbgp2()
		pewaktubg.start()

func buatsoal():
	checkpoint()
	benarp1.disabled = false
	salahp1.disabled = false
	benarp2.disabled = false
	salahp2.disabled = false
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
		soalp1.set_text(globals.soal.keys()[acakbenar])
		soalp1.add_color_override("font_color", ColorN(globals.soal.values()[acakbenar]))
		soalp2.set_text(globals.soal.keys()[acakbenar])
		soalp2.add_color_override("font_color", ColorN(globals.soal.values()[acakbenar]))
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
		soalp1.set_text(globals.soal.keys()[namaacak])
		soalp1.add_color_override("font_color", ColorN(globals.soal.values()[warnaacak]))
		soalp2.set_text(globals.soal.keys()[namaacak])
		soalp2.add_color_override("font_color", ColorN(globals.soal.values()[warnaacak]))
		soalterakhir = str(namaacak, warnaacak)

func cekjawaban():
	if benarp1.pressed and jawaban == true or salahp1.pressed and jawaban == false:
		skor[0] += 1
		skorp1.set_text(str("Score: \n", skor[0], " vs ", skor[1]))
		skorp2.set_text(str("Score: \n", skor[1], " vs ", skor[0]))
		benarp2.disabled = true
		salahp2.disabled = true
		player1benar = true
		hasil = true

	elif benarp1.pressed and jawaban == false or salahp1.pressed and jawaban == true:
		skor[1] += 1
		skorp1.set_text(str("Score: \n", skor[0], " vs ", skor[1]))
		skorp2.set_text(str("Score: \n", skor[1], " vs ", skor[0])) 
		benarp2.disabled = true
		salahp2.disabled = true
		player1benar = false
		hasil = false

	elif benarp2.pressed and jawaban == true or salahp2.pressed and jawaban == false:
		skor[1] += 1
		skorp1.set_text(str("Score: \n", skor[0], " vs ", skor[1])) 
		skorp2.set_text(str("Score: \n", skor[1], " vs ", skor[0]))
		benarp1.disabled = true
		salahp1.disabled = true
		player1benar = false
		hasil = true

	elif benarp2.pressed and jawaban == false or salahp2.pressed and jawaban == true:
		skor[0] += 1
		skorp1.set_text(str("Score: \n", skor[0], " vs ", skor[1])) 
		skorp2.set_text(str("Score: \n", skor[1], " vs ", skor[0]))
		benarp1.disabled = true
		salahp1.disabled = true
		player1benar = true
		hasil = false

	waktu = "-"
	babak += 1
	cekhasil()

func keclap():
	if player1benar == true:
		VisualServer.set_default_clear_color(Color(0,1,0,0.30))
		bgp2.color = Color(1,0,0,0.30)
		#waktu = "BENAR"
	else:
		VisualServer.set_default_clear_color(Color(1,0,0,0.30))
		bgp2.color = Color(0,1,0,0.30)
		#waktu = "SALAH"
	pass

func cekhasil():
	if skor[0] == 20:
		globals.winner = 1
		globals.goto_scene("res://Scene/Result.tscn")
	elif skor[1] == 20:
		globals.winner = 2
		globals.goto_scene("res://Scene/Result.tscn")
	else:
		keclap()
		buatsoal()
	pass

func _on_Pewaktu_timeout():
	milidetik += 1
	pass