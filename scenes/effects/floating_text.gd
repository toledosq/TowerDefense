extends Marker2D

const SPEED = 10
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	global_rotation_degrees = 0
	print("damage text ready")
	$Timer.start()
	
	var color_movement_tween = create_tween().set_parallel()
	var scale_tween = create_tween()
	color_movement_tween.tween_property($Label, 'modulate', Color(1,1,1,0), 1.5)
	color_movement_tween.tween_property($Label, 'position', Vector2(position.x + randi_range(-20, 20), position.y + randi_range(-20, 20)), 2)
	
	scale_tween.tween_property($Label, 'scale', Vector2(2,2), 0.3).from(Vector2(0.5,0.5))
	scale_tween.tween_property($Label, 'scale', Vector2(0.5,0.5), 0.7)
	


func set_text(text):
	$Label.text = str(text)


func _on_timer_timeout():
	queue_free()
