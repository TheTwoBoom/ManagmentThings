extends PanelContainer
@onready var player = %CharacterBody2D

func _on_exit_button_pressed() -> void:
	player.toggleHouseGUI()


func _on_buy_button_pressed() -> void:
	if player.gui_house == Vector2(-1, -1):
		return
	if player.data["coins"] >= player.data["houses"][player.gui_house]["buy_price"]:
		player.data["coins"] -= player.data["houses"][player.gui_house]["buy_price"]
		player.data["houses"][player.gui_house]["owned"] = true
		player.data["owned_houses"] += 1
		%CoinsLabel.text = "Coins: " + str(player.data["coins"])
		%BackgroundStuff.finances["purchases"] -= player.data["houses"][player.gui_house]["buy_price"]
		%HouseLabel.text = "Owned Houses: " + str(player.data["owned_houses"])
		player.toggleHouseGUI()
		print("Bought House!")
