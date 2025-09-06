extends Node

@onready var timelabel = %TimeLabel
@onready var summarypanel = %summaryPanel
@onready var player = %CharacterBody2D

var current_day = 1
var current_hour = 8
var dont_tick = true
var finances = {
	"income": 0,
	"expenses": 0,
	"purchases": 0
}

func _ready() -> void:
	current_day = player.data["day"]
	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(clock_tick)
	self.color = Color(1, 1, 1, 1) # Nacht = dunkel

func fade_to_day() -> void:
	player.speed = 0.3
	var tween = create_tween()
	tween.tween_property(self, "color", Color(1, 1, 1, 1), 4.5) # 4.5 Sek. aufhellen
	var finances = {
		"income": 0,
		"expenses": 0,
		"purchases": 0
	}

func fade_to_night() -> void:
	player.speed = 0
	var tween = create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0.8), 4.5) # 4.5 Sek. abdunkeln
	calculate_finances()
	tween.connect("finished", displaySummary)

func day_tick():
	current_day += 1
	current_hour = 5
	player.data["day"] += 1
	timelabel.text = str(current_day) + get_counting_suffix(current_day) + " Day | " + str(current_hour) + ":00"
	dont_tick = false
	fade_to_day()

func clock_tick():
	if dont_tick:
		return
	if current_hour == 18:
		fade_to_night()
	elif current_hour > 20:
		return
	current_hour += 1
	timelabel.text = str(current_day) + get_counting_suffix(current_day) + " Day | " + str(current_hour) + ":00"

func get_counting_suffix(day: int) -> String:
	var last_two = day % 100
	if last_two >= 11 and last_two <= 13:
		return "th"
	
	match day % 10:
		1:
			return "st"
		2:
			return "nd"
		3:
			return "rd"
		_:
			return "th"

func calculate_finances():
	for i in player.data["houses"]:
		if player.data["houses"][i]["owned"]:
			finances["income"] += player.data["houses"][i]["rent"]
			finances["expenses"] -= player.data["houses"][i]["maintenance_cost"]

func displaySummary():
	%summaryPanel.visible = true
	%IncomeLabel.text = str(finances["income"])
	%ExpensesLabel.text = str(finances["expenses"])
	%PurchasesLabel.text = str(finances["purchases"])
	%TotalLabel.text = str(finances["income"] + finances["expenses"] + finances["purchases"])
	player.data["coins"] += finances["income"] + finances["expenses"]
	%CoinsLabel.text = "Coins: " + str(player.data["coins"])
	dont_tick = true
	
