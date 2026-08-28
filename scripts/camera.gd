extends Camera2D

func move_camera(position_to_move:Vector2) -> void:
	position = position_to_move

func zoom_camera(scale: int) -> void:
	var zoom_target := zoom / scale
	var tween := create_tween()
	tween.set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", zoom_target, 0.8)
