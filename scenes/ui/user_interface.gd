extends CanvasLayer


signal building_selected(selected: bool)

# Counters and containers
@onready var building_buttons_container = %BuildingButtonGrid
@onready var wave_counter = %WaveCounter
@onready var tower_counter = %TowerCounter
@onready var enemies_killed_counter = %EnemiesKilledCounter
@onready var enemies_killed_progress_bar = %EnemiesKilledProgressBar
@onready var game_over_screen = $GameOverScreen
@onready var currency_counter = %CurrencyCounter


# Tower build menu buttons
@onready var arrow_tower_button = %ArrowTowerButton
@onready var cannon_tower_button = %CannonTowerButton
@onready var lightning_tower_button = %LightningTowerButton


# End of round stats
@onready var eor_waves_survived = %Label_WavesSurvivedCounter
@onready var eor_enemies_killed = %Label_EnemiesKilledCounter
@onready var eor_towers_built = %Label_TowersBuiltCounter
@onready var eor_currency_amount = %Label_CurrencyCounter


func _ready():
	# Hide Game Over screen
	game_over_screen.visible = false
	
	# Connect to Global stats for updating UI
	Globals.connect("wave_changed", update_wave_label)
	Globals.connect("currency_changed", update_currency_label)
	Globals.connect("tower_count_changed", update_tower_count_label)
	Globals.connect("enemies_killed_changed", update_enemies_killed_stats)
	Globals.connect("enemies_in_wave_changed", update_enemies_killed_progress_bar_max_value)
	Globals.connect("on_victory", show_victory_popup)
	Globals.connect("on_defeat", show_victory_popup)
	
	# Update UI with initial stats
	update_wave_label()
	update_tower_count_label()
	update_currency_label()
	update_enemies_killed_stats()
	update_enemies_killed_progress_bar_max_value()
	update_towers_build_buttons()


func _on_arrow_tower_button_toggled(button_pressed):
	if button_pressed:
		print("Arrow Tower Build Button Toggled")
		building_selected.emit('arrow_tower')


func _on_cannon_tower_button_toggled(button_pressed):
	if button_pressed:
		print("Cannon Tower Build Button Toggled")
		building_selected.emit('cannon_tower')


func _on_lightning_tower_button_toggled(button_pressed):
	if button_pressed:
		print("Lightning Tower Build Button Toggled")
		building_selected.emit('lightning_tower')


# Re-enable the building buttons
func _on_level_building_state_exited():
	for button in building_buttons_container.get_children():
		if button is Button:
			button.button_pressed = false


func update_wave_label():
	wave_counter.text = str(Globals.wave)


func update_tower_count_label():
	tower_counter.text = str(Globals.tower_count)


func update_currency_label():
	currency_counter.text = str(Globals.currency)
	# Update available options in the build menu
	update_towers_build_buttons()


func update_towers_build_buttons():
	if Globals.currency >= Globals.tower_cost['arrow_tower']:
		arrow_tower_button.disabled = false
	else:
		arrow_tower_button.disabled = true
		
	if Globals.currency >= Globals.tower_cost['cannon_tower']:
		cannon_tower_button.disabled = false
	else:
		cannon_tower_button.disabled = true
		
	if Globals.currency >= Globals.tower_cost['lightning_tower']:
		lightning_tower_button.disabled = false
	else:
		lightning_tower_button.disabled = true


func update_enemies_killed_stats():
	enemies_killed_counter.text = str(Globals.enemies_killed)
	enemies_killed_progress_bar.value = Globals.enemies_killed


func update_enemies_killed_progress_bar_max_value():
	enemies_killed_progress_bar.max_value = Globals.enemies_in_wave


# GAME OVER SCREEN 
func show_victory_popup():
	# Make gameover screen fade in over game
	game_over_screen.visible = true
	$GameOverScreen/AnimationPlayer.play("fade_in")
	
	# Change behavior on victory or defeat
	var waves_survived = Globals.wave
	if Globals.victory:
		%VictoryOrDefeatLabel.text = 'VICTORY!'
	else:
		%VictoryOrDefeatLabel.text = 'DEFEAT'
		waves_survived -= 1  # Don't count current wave
		
	# Update end of round stats
	eor_waves_survived.text = str(waves_survived)
	eor_enemies_killed.text = str(Globals.enemies_killed)
	eor_towers_built.text = str(Globals.tower_count)
	eor_currency_amount.text = str(Globals.currency)
	
	# Fade in the end of round stats one by one
	var tween = create_tween()
	for container in %VBox_StatsList.get_children():
		for label in container.get_children():
			tween.tween_property(label, "modulate", Color(1,1,1,1), 0.5).from(Color(0,0,0,0))


func hide_victory_popup():
	game_over_screen.visible = false


func _on_play_button_pressed():
	hide_victory_popup()
	# Change scene/ reset level
	LevelTransition.change_scene(Globals.next_level)


func _on_quit_button_pressed():
	# Return to main menu
	LevelTransition.change_scene("res://scenes/levels/main.tscn")


