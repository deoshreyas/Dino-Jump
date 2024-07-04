extends Node

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().paused = false 
		get_parent().new_game()
		get_parent().game_started = true
		get_parent().get_child(4).get_child(0).get_child(2).visible = false
		get_parent().new_game()
