extends Area2D

signal hit

export var speed: float = 600.0
# On ready vars
onready var bounds: Vector2 = get_viewport_rect().size
onready var animations: AnimatedSprite = $AnimatedSprite

func _process(delta):
	# Handle inputs
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	# If the player is moving
	if direction.length() > 0:
		# normalize direction
		direction = direction.normalized()
		# play animation
		animations.play()
		# Filp sprite accordingly
		animations.flip_v = direction.y > 0
		animations.flip_h = direction.x < 0
		# Set animation
		if direction.x != 0:
			animations.animation = "right"
		else:
			animations.animation = "up"
	# If is not moving stop the animation
	else:
		animations.stop()
	
	# Update positions
	position += direction * speed * delta
	# Clap position to the screen
	position.x = clamp(position.x, 0, bounds.x)
	position.y = clamp(position.y, 0, bounds.y)

func start(start_position: Vector2):
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	position = start_position

func disbled():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_Player_body_entered(body):
	disbled()
	emit_signal("hit")
