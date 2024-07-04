extends Node

const DINO_START_POS = Vector2(21, 135)
const CAM_START_POS = Vector2(0, 0)
const GROUND_START_POS = Vector2(0, 0)
var speed
const START_SPEED = 2
const MAX_SPEED = 25
@onready var screen_size = get_window().size
@onready var ground_height = $Ground.get_node("Sprite2D").texture.get_height()

var score:
	get:
		return score 
	set(value):
		score = value
		$HUD/Control/Score.text = str(score/10)
		
var game_started = false

@export var obstacles : Array[PackedScene]
var bird_heights = [40, 100, 150]
var current_obstacles = []
var last_obs

func _ready():
	new_game()

func new_game():
	score = 0
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = GROUND_START_POS
	game_started = false
	$HUD/Control/Begin.visible = true
	
func _process(_delta):
	if game_started:
		speed = START_SPEED + score / 5000
		speed = clamp(speed, START_SPEED, MAX_SPEED)
		
		generate_obstacle()
		
		$Dino.position.x += speed 
		$Camera2D.position.x += speed
		score += speed
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		$Dino/AnimatedSprite2D.play("idle")
		if Input.is_action_just_pressed("jump"):
			game_started = true
			$HUD/Control/Begin.visible = false
	
func generate_obstacle():
	if current_obstacles.is_empty():
		var obstacle_scene = obstacles.pick_random()
		var obstacle = obstacle_scene.instantiate()
		var obs_x = screen_size.x + 100
		var obs_height = obstacle.get_node("Sprite2D").texture.get_height()
		var obs_scale = obstacle.scale
		var obs_y = screen_size.y - ground_height.y - (obs_height + obs_scale/2) + 5
		last_obs = obstacle
		obstacle.position = Vector2(obs_x, obs_y)
		add_child(obstacle)
		current_obstacles.append(obstacle)
