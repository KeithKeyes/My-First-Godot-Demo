extends Node

var score = 0

onready var mobtimer = $MobTimer
onready var scoretimer = $ScoreTimer
onready var starttimer = $StartTimer
onready var startposition = $StartPosition
onready var moblocation = $MobPath/MobLocation
onready var music = $Music
onready var deathsoundeffect = $DeathSoundEffect

var Mob = preload("res://Mob.tscn")

func _ready():
	randomize()

func game_over():
	scoretimer.stop()
	mobtimer.stop()
	$HUD.game_over()
	deathsoundeffect.play()
	music.stop()
	$Player/InvincibleTimer.stop()
	
func game_start():
	score = 0
	$Player.start(startposition.position)
	starttimer.start()
	$HUD.score_record(score)
	$HUD.show_message("Get Ready")
	music.play()
	
func _on_StartTimer_timeout():
	scoretimer.start()
	mobtimer.start()
	$Player/InvincibleTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.score_record(score)

func _on_MobTimer_timeout():
	generate_mob()
	
func generate_mob():
	moblocation.unit_offset = randf()
	var mob = Mob.instance()
	add_child(mob)
	mob.position = moblocation.position
	var direction = moblocation.rotation + PI/2 + rand_range(-PI/4, PI/4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.speed_min, mob.speed_max) ,0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")
	 
func _on_HUD_start_game():
	game_start()

func _on_Player_invincible_time_changed(time):
	if $Player.visible == false:
		$HUD.invincible_count(0.0)
	else:
		$HUD.invincible_count(time)
