extends Area2D
class_name Bird

func _process(delta):
	position.x -= get_parent().speed / 2 
