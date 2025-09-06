extends TextureButton
@onready var player = %CharacterBody2D

func _on_pressed() -> void:
	player.data["tutorial"] = true
	%tutorialUI.visible = false
	%BackgroundStuff.dont_tick = false
	%CharacterBody2D.freeze = false
