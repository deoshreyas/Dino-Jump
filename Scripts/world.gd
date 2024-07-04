extends Node

const DINO_START_POS = Vector2(21, 135)
const CAM_START_POS = Vector2(0, 0)
const GROUND_START_POS = Vector2(0, 0)

var speed
const START_SPEED = 2.5
const MAX_SPEED = 25.0
var screen_size : Vector2

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = GROUND_START_POS

func _process(_delta):
	speed = START_SPEED
	$Dino.position.x += speed 
	$Camera2D.position.x += speed
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
