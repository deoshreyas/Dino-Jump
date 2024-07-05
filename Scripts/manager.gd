extends Node

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().paused = false 
		get_parent().game_started = true
		get_parent().check_score()
		get_parent().get_child(4).get_child(0).get_child(2).visible = false
		get_parent().new_game()
		for obs in get_parent().current_obstacles:
			obs.queue_free()
		get_parent().current_obstacles.clear()
