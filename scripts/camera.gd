extends Camera2D

func move_camera(position_to_move:Vector2) -> void:
	position = position_to_move

func zoom_camera(scale: int) -> void:
	print(scale)
	zoom /= scale
