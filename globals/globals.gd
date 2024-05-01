extends Node

# Variable setter signals
signal game_started
signal on_victory
signal on_defeat
signal tower_count_changed
signal tower_selected
signal wave_changed
signal currency_changed
signal enemies_in_wave_changed
signal enemies_alive_changed
signal enemies_killed_changed


# Building Placement Tile Size
const tile_size = 32

# Colors
const building_placement_valid: Color = Color(0.1, 1, 0.2, 0.5)
const building_placement_invalid: Color = Color(1, 0.1, 0.2, 0.5)
const WHITE: Color = Color(1,1,1,1)

# Tower Costs
const tower_cost: Dictionary = {
	'arrow_tower': 25,
	'cannon_tower': 50,
	'lightning_tower': 100
}
# Multipliers: Health, Speed, Wave size
const difficulty_multipliers: Dictionary = {
	'easy': [1,1,1,1],
	'medium': [1.5, 1.2, 1.5, 1.5],
	'hard': [2, 1.3, 2, 2]
}

var difficulty: String = 'easy'

var game_active: bool = false:
	get:
		return game_active
	set(value):
		game_active = value
		game_started.emit()

var victory: bool = false:
	get:
		return victory
	set(value):
		victory = value
		on_victory.emit()

var defeat: bool = false:
	get:
		return defeat
	set(value):
		defeat = value
		on_defeat.emit()

var currency: int = 0:
	get:
		return currency
	set(value):
		currency = value
		currency_changed.emit()

var selected_tower: towerParent:
	get:
		return selected_tower
	set(value):
		selected_tower = value
		tower_selected.emit(value)

var tower_count: int:
	get:
		return tower_count
	set(value):
		tower_count = value
		tower_count_changed.emit()

var wave: int:
	get:
		return wave
	set(value):
		wave = value
		wave_changed.emit()

var enemies_in_wave: int:
	get:
		return enemies_in_wave
	set(value):
		enemies_in_wave = value
		enemies_in_wave_changed.emit()

var enemies_alive: int:
	get:
		return enemies_alive
	set(value):
		enemies_alive = value
		enemies_alive_changed.emit()

var enemies_killed: int:
	get:
		return enemies_killed
	set(value):
		enemies_killed = value
		enemies_killed_changed.emit()

var current_level: String = "res://scenes/levels/levels/windy_road_level.tscn"

var next_level: String = "res://scenes/levels/levels/windy_road_level.tscn"
