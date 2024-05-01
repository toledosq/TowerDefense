extends Node2D

class_name levelParent

signal building_state_exited
signal level_completed

var mouse_position: Vector2 = Vector2.ZERO


var selected_tower: towerParent
var selected_type: String
var tower_types: Dictionary = {
	'lightning_tower': preload("res://scenes/towers/lightning_tower.tscn"),
	'arrow_tower': preload("res://scenes/towers/arrow_tower.tscn"),
	'cannon_tower': preload("res://scenes/towers/cannon_tower.tscn")
}

var enemy_path: PackedScene
var enemy_types: Dictionary = {
	'grunt': preload("res://scenes/units/unit.tscn")
}

# Starting parameters
@export var difficulty: String = 'easy'
@export var waves: int = 1
@export var enemies_in_wave: int = 1
@export var starting_currency: int = 50
var spawns_remaining: int = 1


func _ready():
	on_ready()
	
func on_ready():
	Globals.difficulty = difficulty
	Globals.wave = 1
	enemies_in_wave *= Globals.difficulty_multipliers[Globals.difficulty][2]
	Globals.enemies_in_wave = enemies_in_wave
	Globals.tower_count = 0
	Globals.enemies_killed = 0
	Globals.enemies_alive = 0
	Globals.game_active = true
	Globals.currency = starting_currency
	
	$UserInterface.update_towers_build_buttons()
	spawns_remaining = enemies_in_wave
	$SpawnTimer.start(5)


# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	if Globals.game_active:
		mouse_position = get_global_mouse_position()
		if Globals.enemies_killed >= Globals.enemies_in_wave:
			print("Game Over - You won!!!")
			Globals.game_active = false
			Globals.victory = true


# When the user toggles a building mode button
func _on_user_interface_building_selected(selected):
	selected_tower = tower_types[selected].instantiate()
	selected_type = selected
	selected_tower.modulate = Globals.building_placement_valid
	$Towers.add_child(selected_tower)
	$StateChart.send_event("building_selected")


# Check input while building mode is active
func check_building_state_input():
	# Tower follows mouse
	selected_tower.global_position = mouse_position
	# snaps to the nearest point on a tile_size pixel grid
	selected_tower.position = selected_tower.position.snapped(Vector2.ONE * Globals.tile_size)
	# Moves to center of tile
	selected_tower.position += Vector2.ONE * Globals.tile_size / 2
	
	if Input.is_action_just_pressed("LeftMouseClick"):
		# clear selected tower and increment tower built count
		selected_tower.can_attack = true
		selected_tower.modulate = Globals.WHITE
		selected_tower = null
		Globals.currency -= Globals.tower_cost[selected_type]
		selected_type = ''
		Globals.tower_count += 1
		$StateChart.send_event("go_to_idle")
		
	elif Input.is_action_just_pressed("RightMouseClick"):
		# Remove the building from the ghosts
		selected_tower.queue_free()
		selected_tower = null
		selected_type = ''
		$StateChart.send_event("go_to_idle")


func spawn_enemy(enemy_type: String):
	var num_spawns: int = randi_range(1,5)
	for i in range(num_spawns):
		if spawns_remaining > 0:
			
			print("init path")
			var path = enemy_path.instantiate()
			path.position += Vector2(randi_range(-30,30), randi_range(-30,30))
			
			print("spawn enemy")
			var enemy = enemy_types[enemy_type].instantiate()
			
			print("add enemy to path")
			path.get_child(0).add_child(enemy)
			
			print("add path to tree")
			$PathSpawner.add_child(path)
			
			enemy.alive = true
			Globals.enemies_alive += 1
			spawns_remaining -= 1
	$SpawnTimer.start(randf_range(2, 5))


func _on_building_state_state_physics_processing(_delta):
	check_building_state_input()


func _on_building_state_state_exited():
	building_state_exited.emit()


# Spawn an enemy
func _on_spawn_timer_timeout():
	spawn_enemy('grunt')


# Game over if enemy makes it to here
func _on_finish_line_area_entered(_area):
	print("Game over!")
	Globals.game_active = false
	Globals.defeat = true
