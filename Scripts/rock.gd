extends Area2D
class_name Rock

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
