extends Area2D
class_name Bird

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _process(delta):
	position.x -= get_parent().speed / 2 
