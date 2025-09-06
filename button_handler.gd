extends MarginContainer


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_stats_button_pressed() -> void:
	get_tree().change_scene_to_file("res://stats.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
