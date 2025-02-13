extends CharacterBody2D


@export var speed = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = null
var chasePlayer = false
var direction = -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player:
		if (position.x < player.position.x):
			direction = 1
		else:
			direction = -1
	if chasePlayer:
		velocity.x  = direction * speed
	else:
		velocity.x = 0
		

	move_and_slide()


func _on_area_2d_body_entered(body):
	player = body
	chasePlayer = true


func _on_area_2d_body_exited(body):
	player = null
	chasePlayer = false
