extends PanelContainer
@onready var player = %CharacterBody2D

func _on_quit_button_pressed() -> void:
	player.save_game()
	get_tree().change_scene_to_file("res://game.tscn")


func _on_next_day_button_pressed() -> void:
	self.visible = false
	player.save_game()
	%BackgroundStuff.day_tick()
