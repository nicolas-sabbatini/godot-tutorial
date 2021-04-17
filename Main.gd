extends Node

export var mobs_scene: PackedScene
export var max_difficulty: int = 10
export var dificulty_increase: int = 30
var difficulty: int = 1
var steps: int = 0
var score: int = 0

# Childrens
onready var spawn_point: PathFollow2D = $mob_path/spawn_point
onready var score_timer: Timer = $score_timer
onready var spawn_timer: Timer = $spawn_timer
onready var hud = $HUD
onready var player = $Player

func _ready():
	player.disbled()
	randomize()

func new_game():
	# Set score to 0
	score = 0
	difficulty = 1
	steps = 0
	hud.update_score(score)
	hud.dispay_message("Get ready...")
	get_tree().call_group("mobs", "queue_free")
	yield(get_tree().create_timer(1.0), "timeout")
	hud.hide_mesage()
	score_timer.start()
	spawn_timer.start()
	player.start(Vector2(2048/2, 1200/2))

func game_over():
	score_timer.stop()
	spawn_timer.stop()
	$Music.stop()
	$DeadSound.play()
	hud.dispay_message("Game Over =(\n Try again?")
	yield(get_tree().create_timer(1.0), "timeout")	
	hud.show_button()
	

func _on_spawn_timer_timeout():
	# Spawn amount depending of the difficulty
	for i in difficulty:
		# Get random spawn point
		spawn_point.unit_offset = randf()
		# Create new mob
		var new_mob = mobs_scene.instance()
		# add to scene
		add_child(new_mob)
		# Set position
		new_mob.position = spawn_point.position
		#Set direction
		var direction = spawn_point.rotation + PI / 2
		direction += rand_range(- PI / 4, PI / 4)
		new_mob.rotation = direction
		# Set velocity
		var vel = Vector2(rand_range(new_mob.min_speed, new_mob.max_speed), 0)
		new_mob.linear_velocity = vel.rotated(direction)
	# increase step count
	steps += 1
	if steps > dificulty_increase:
		steps = 0
		difficulty = min(difficulty + 1, max_difficulty)
		print(difficulty)


func _on_score_timer_timeout():
	score += 1
	hud.update_score(score)
	


func _on_DeadSound_finished():
	$Music.play()
