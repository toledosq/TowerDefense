extends levelParent


func _ready():
	enemy_path = preload("res://scenes/levels/levels/castle_path.tscn")
	on_ready()

# Spawn an enemy
func _on_spawn_timer_timeout():
	spawn_enemy('grunt')
