extends CanvasLayer

signal start_game

onready var score: Label = $score
onready var message: Label = $message

func update_score(new_score: int):
	score.text = str(new_score)

func dispay_message(new_message: String):
	message.text = new_message
	message.show()

func hide_mesage():
	message.hide()

func show_button():
	$Button.show()

func _on_Button_pressed():
	$Button.hide()
	emit_signal("start_game")
	update_score(0)
