extends CharacterBody2D

@onready var houseGUI = %houseGUI

var speed = 0.3
var direction = "down"
var globalObj = 0
var data = {
	"tutorial": false,
	"coins": 1000,
	"owned_houses": 0,
	"day": 1,
	"houses": {
		Vector2(-4, 6): {"owned": false, "buy_price": 1000, "sell_price": -1, "rent": 50, "market_bonus": 0, "maintenance_cost": 10},
		Vector2(2, 6): {"owned": false, "buy_price": 500, "sell_price": -1, "rent": 50, "market_bonus": 0, "maintenance_cost": 25},
	}
}
var selected_house = Vector2(-1, -1)
var gui_house = Vector2(-1, -1)
var last_key_status = false
var freeze = true

var save_path := "user://savegame.save"
var autosave_timer: Timer


func _ready() -> void:
	load_game()
	%CoinsLabel.text = "Coins: " + str(data["coins"])
	%HouseLabel.text = "Owned Houses: " + str(data["owned_houses"])
	if data["tutorial"]:
		%tutorialUI.visible = false
		%BackgroundStuff.dont_tick = false
		%CharacterBody2D.freeze = false
	# Timer einrichten
	autosave_timer = Timer.new()
	autosave_timer.wait_time = 30.0
	autosave_timer.autostart = true
	autosave_timer.one_shot = false
	autosave_timer.timeout.connect(save_game)
	add_child(autosave_timer)

func _physics_process(delta: float):
	velocity = Vector2(0, 0)
	if Input.is_physical_key_pressed(KEY_E) != last_key_status and !last_key_status:
		if selected_house != Vector2(-1, -1) or houseGUI.visible:
			toggleHouseGUI()
	last_key_status = Input.is_physical_key_pressed(KEY_E)
	
	if freeze:
		return
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = "up"
		pass
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = "down"
		hideTooltip()
		pass
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = "left"
		hideTooltip()
		pass
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = "right"
		hideTooltip()
		pass
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * 1000
		$AnimatedSprite2D.play("walking_" + direction)
	else:
		$AnimatedSprite2D.play("idle_" + direction)
	move_and_slide()

func _process(delta: float):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var cell = Vector2(%GameTileMap.local_to_map(%GameTileMap.to_local(global_position)))
		if data["houses"].has(cell) and globalObj is int:
			globalObj = showTooltip(global_position)
			selected_house = cell
			print("Found House! Rent: ", data["houses"][cell]["rent"])

func showTooltip(posVector: Vector2):
		# Datei laden
	var scene = load("res://tooltip.tscn")
	var obj = scene.instantiate()

	# Position setzen (falls es ein Node2D ist)
	obj.global_position = Vector2(-80, -80)
	obj.name = "tooltip"

	# Zum aktuellen Node hinzufügen
	add_child(obj)
	return obj

func hideTooltip():
	selected_house = Vector2(-1, -1)
	for i in get_children(false):
		if i.name.begins_with("tooltip"):
			i.queue_free()
			globalObj = 0

func toggleHouseGUI():
	%BackgroundStuff.dont_tick = !houseGUI.visible
	freeze = !houseGUI.visible
	if houseGUI.visible:
		gui_house = Vector2(-1, -1)
	else:
		gui_house = selected_house
		%PriceLabel.text = "Purchase Price: " + str(data["houses"][gui_house]["buy_price"]) + " Coins"
		%MaintenanceLabel.text = "Maintenance Cost: " + str(data["houses"][gui_house]["maintenance_cost"]) + " Coins"
		%RentLabel.text = "Base Rent: " + str(data["houses"][gui_house]["rent"]) + " Coins"
		%BonusLabel.text = "Market Bonus: +" + str(data["houses"][gui_house]["market_bonus"]) + "%"
		if data["houses"][gui_house]["owned"]:
			%BuyButton.visible = false
	houseGUI.visible = !houseGUI.visible
	print(gui_house)

func save_game():
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()

func load_game():
	if not FileAccess.file_exists(save_path):
		return {}
	var file := FileAccess.open(save_path, FileAccess.READ)
	data = file.get_var()
	file.close()
	return data
