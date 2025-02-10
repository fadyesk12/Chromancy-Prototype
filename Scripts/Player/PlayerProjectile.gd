extends Area2D


@export var speed = 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
var direction = 0.0
var initial_position = Vector3.ZERO
var increment = 0
@onready var projectileTimeout = $Timer
func _physics_process(delta):
	if projectileTimeout.is_stopped():
		projectileTimeout.start()
	increment += speed * direction
	global_position.x = initial_position.x + increment

func destroy():
	queue_free()
	


func _on_area_entered(area):
	destroy()
	pass


func _on_area_exited(area):
	destroy()
	pass


func _on_timer_timeout():
	destroy()
