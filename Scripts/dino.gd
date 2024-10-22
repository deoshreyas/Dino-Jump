extends CharacterBody2D
class_name Dino

const GRAVITY = 4200
const JUMP_SPEED = -800

@onready var animation = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += GRAVITY * delta 
	if is_on_floor():
		$RunCol.disabled = false
		$DuckCol.disabled = true
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
			$JumpSound.play()
		elif Input.is_action_pressed("down"):
			animation.play("duck")
			$RunCol.disabled = true
			$DuckCol.disabled = false
		else:
			animation.play("run")
	else:
		animation.play("jump")
		
	move_and_slide()
