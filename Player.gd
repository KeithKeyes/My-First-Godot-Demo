extends Area2D

signal hit
signal invincible_time_changed(time)

export var speed = 400
var screen_size 
var invincible = false
var invincible_time_amount = 0.0 setget set_invincible_time

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if velocity != Vector2():
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		$Shadow.emitting = true
	else:
		$AnimatedSprite.stop()
		$Shadow.emitting = false
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
	if Input.is_action_pressed("invincible") and self.invincible_time_amount > 0:
		invincible = true
		self.invincible_time_amount -= delta
	else:
		invincible = false
		
	if invincible:
		$AnimatedSprite.modulate = Color("c83232")
	else:
		$AnimatedSprite.modulate = Color("ffffff")
		
		

func _on_Player_body_entered(body):
	if not invincible:
		hide()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		body.queue_free()
	
func start(pos):
	position = pos
	$AnimatedSprite.animation = "up"
	$AnimatedSprite.frame = 0 
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.flip_h = false
	$CollisionShape2D.disabled = false
	show()
	self.invincible_time_amount = 0.0
	invincible = false
	
func set_invincible_time(value):
	if self.invincible_time_amount == value:
		return
	elif visible == false:
		return
	else:
		invincible_time_amount = value
		emit_signal("invincible_time_changed", self.invincible_time_amount)

func _on_InvincibleTimer_timeout():
	self.invincible_time_amount += 1.0
