extends CanvasLayer


func _on_play_button_pressed():
	LevelTransition.change_scene("res://scenes/levels/levels/castle_level.tscn")


func _on_quit_button_pressed():
	get_tree().quit(0)
