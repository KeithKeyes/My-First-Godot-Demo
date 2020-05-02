extends RigidBody2D

export var speed_max = 250
export var speed_min = 150
var mob_types = ["Walk", "Swim", "Fly"]

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
func _on_start_game():
	queue_free()
