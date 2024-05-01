extends StaticBody2D

class_name towerParent


var target: CharacterBody2D
var can_attack: bool = true
var damage: int = 1
var cooldown: int = 1


func attack():
	print("pew pew!!")
	if target != null and 'hit' in target:
		target.hit(damage)
		can_attack = false
		$AttackCooldown.start(cooldown)
		# hit effect from tower
		spawn_hit_effect(target.global_position)


func spawn_hit_effect(_pos):
	pass


func _on_attack_cooldown_timeout():
	can_attack = true


func _on_attack_area_area_exited(_area):
	$StateChart.send_event("no_target")


func _on_attack_state_physics_processing(_delta):
	if can_attack:
		attack()


func _on_idle_state_entered():
	can_attack = false
	target = null


func _on_idle_state_physics_processing(_delta):
	find_targets()


func find_targets():
	# Check for targets
	if %AttackArea.has_overlapping_areas():
		target = %AttackArea.get_overlapping_areas()[0].get_parent()
		$StateChart.send_event("enemy_detected")
