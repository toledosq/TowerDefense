extends CharacterBody2D

@export var hit_points: int = 5
@export var speed: int = 30
@export var reward: int = 5
@export var type: String = "Unit"

var floating_text = preload("res://scenes/effects/floating_text.tscn")

var alive = false
var path_follow


func _ready():
	get_difficulty()
	$AnimatedSprite2D.play("walking")
	path_follow = get_parent()


func get_difficulty():
	hit_points *= Globals.difficulty_multipliers[Globals.difficulty][0]
	speed *= Globals.difficulty_multipliers[Globals.difficulty][1]
	reward *= Globals.difficulty_multipliers[Globals.difficulty][3]


func _physics_process(delta):
	if Globals.game_active and alive:
		move(delta)


func move(delta):
	path_follow.set_progress(path_follow.get_progress() + speed * delta)
	if path_follow.get_progress_ratio() == 1:
		queue_free()
	# position += dir * speed * delta


func hit(damage):
	if alive:
		hit_points -= damage
		display_hit_damage(damage)
		if hit_points <= 0:
			die()


func display_hit_damage(damage):
	# Instantiate floating text and assign damage amount to label
	var damage_text = floating_text.instantiate()
	damage_text.set_text(damage)
	# Move floating text to unit's position
	damage_text.global_position = global_position
	damage_text.position = position
	# Add to scene
	add_child(damage_text)


func die():
	alive = false
	Globals.enemies_alive -= 1
	Globals.enemies_killed += 1
	Globals.currency += reward
	$DetectionArea.queue_free()
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	path_follow.get_parent().queue_free()
	queue_free()
