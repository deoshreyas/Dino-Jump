extends CharacterBody2D

const GRAVITY = 4200
const JUMP_SPEED = -600

@onready var animation = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += GRAVITY * delta 
	if is_on_floor():
		$RunCol.disabled = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
			$JumpSound.play()
		elif Input.is_action_pressed("down"):
			animation.play("duck")
			$RunCol.disabled = true
		else:
			animation.play("run")
	else:
		animation.play("jump")
		
	move_and_slide()
