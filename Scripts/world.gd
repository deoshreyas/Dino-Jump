extends Node

const DINO_START_POS = Vector2(21, 135)
const CAM_START_POS = Vector2(0, 0)
const GROUND_START_POS = Vector2(0, 0)
var speed
const START_SPEED = 5
const MAX_SPEED = 25
@onready var screen_size = get_window().size

var score:
	get:
		return score
	set(value):
		score = value
		$HUD/Control/Score.text = str(score/10)
		
var game_started = false

var difficulty 
const MAX_DIFFICULTY = 2

var bird = preload("res://Scenes/bird.tscn")
@export var obstacles : Array[PackedScene]
var current_obstacles = []
var last_obs

@onready var score_label = $HUD/Control/Score

func set_hi_score_label(value):
	$HUD/Control/HiScore.text = "HI-SCORE: " + str(value)

func get_hi_score():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		var high_score = save_file.get_32() 
		return high_score
	else:
		var high_score = 0
		save_file.store_32(0)
		return high_score
	
func set_hi_score(value):
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(value)

func _ready():
	new_game()
	var high_score = get_hi_score()
	set_hi_score_label(high_score)
	
func check_score():
	if score!=null:
		if score/10>get_hi_score():
			set_hi_score(score/10)
			set_hi_score_label(score/10)
		else:
			set_hi_score_label(get_hi_score())

func new_game():
	check_score()
	score = 0
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = GROUND_START_POS
	difficulty = 0
	
func _process(_delta):
	if game_started:
		speed = START_SPEED + score / 5000
		speed = clamp(speed, START_SPEED, MAX_SPEED)
		adjust_difficulty()
		
		generate_obstacle()
		
		$Dino.position.x += speed 
		$Camera2D.position.x += speed
		score += speed
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
		
		for obs in current_obstacles:
			if obs.position.x < $Camera2D.position.x - screen_size.x:
				obs.queue_free()
				current_obstacles.erase(obs)
	else:
		$Dino/AnimatedSprite2D.play("idle")
		if Input.is_action_just_pressed("jump"):
			game_started = true
			$HUD/Control/Begin.visible = false
			get_tree().paused = false
	
func generate_obstacle():
	if current_obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obstacle_scene = obstacles.pick_random()
		var no_of_obstacles_to_spawn = difficulty + 1
		for i in range(no_of_obstacles_to_spawn):
			var obstacle = obstacle_scene.instantiate()
			var obs_x = screen_size.x + score + 10 + (i*25)
			var obs_y = 144 
			last_obs = obstacle
			obstacle.position = Vector2(obs_x, obs_y)
			add_child(obstacle)
			current_obstacles.append(obstacle)
			obstacle.body_entered.connect(obs_hit)
		if difficulty==MAX_DIFFICULTY:
			if [true, false].pick_random():
				var obstacle = bird.instantiate()
				var obs_x = screen_size.x + score + 10
				var obs_y = randi_range(115, 160)
				obstacle.position = Vector2(obs_x, obs_y)
				add_child(obstacle)
				current_obstacles.append(obstacle)
				obstacle.body_entered.connect(obs_hit)

func adjust_difficulty():
	difficulty = clamp(score / 5000, 0, MAX_DIFFICULTY) 
	
func obs_hit(body):
	if body is Dino:
		game_over()

func game_over():
	game_started = false
	$HUD/Control/Begin.visible = true
	get_tree().paused = true
