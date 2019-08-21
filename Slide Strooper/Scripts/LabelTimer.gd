extends Label

var detik = 3
var milidetik = 0


func _ready():
	globals.pewaktu.start()

func _process(delta):
	if milidetik > 9:
		detik -= 1
		milidetik = 0
	
	if detik == 0:
		detik = 3
		globals.soal.buatsoal()
		print("ANDA KEHABISAN WAKTU")
	
	set_text(str(detik))
	pass

func _on_Timer_timeout():
	milidetik += 1
	pass