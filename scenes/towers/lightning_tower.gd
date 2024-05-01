extends towerParent

var hit_effect: PackedScene = preload("res://scenes/effects/lightning_impact.tscn")
var explosion_radius: int = 100

func _ready():
	damage = 3
	cooldown = 2


func spawn_hit_effect(pos):
	var hit_effect_instance: AnimationPlayer = hit_effect.instantiate()
	$Projectiles.add_child(hit_effect_instance)
	for child in hit_effect_instance.get_children():
		child.global_position = pos
	hit_effect_instance.play("lightning_impact")
	var targets = get_tree().get_nodes_in_group("Units")
	for target_ in targets:
		var in_range: bool = target_.global_position.distance_to(pos) < explosion_radius
		if in_range and 'hit' in target_:
			target_.hit(damage)
		
