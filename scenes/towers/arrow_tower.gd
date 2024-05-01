extends towerParent

var hit_effect: PackedScene = preload("res://scenes/effects/arrow_impact.tscn")

func _ready():
	damage = 2
	cooldown = 1
	


func spawn_hit_effect(pos):
	var hit_effect_instance: GPUParticles2D = hit_effect.instantiate()
	$Projectiles.add_child(hit_effect_instance)
	hit_effect_instance.global_position = pos
	hit_effect_instance.emitting = true
