extends CanvasLayer

signal start_game

onready var score_label = $ScoreLabel
onready var message_label = $MessageLabel
onready var message_timer = $MessageTimer
onready var start_botton = $StartButton
onready var invincible_lable = $InvincibleLabel

func show_message(text):
	message_label.text = text
	message_label.show()
	message_timer.start()
	
func game_over():
	show_message("Game Over!")
	yield(message_timer, "timeout")
	message_label.text = "Dodge the Creeps!"
	message_label.show()
	yield(get_tree().create_timer(1), "timeout")
	start_botton.show()
	
func score_record(score):
	score_label.text = str(score)
	
func invincible_count(invincible_time_left):
	invincible_lable.text = str(stepify(invincible_time_left, 0.1))
	
func _on_MessageTimer_timeout():
	message_label.hide()

func _on_StartButton_pressed():
	start_botton.hide()
	emit_signal("start_game")
	

