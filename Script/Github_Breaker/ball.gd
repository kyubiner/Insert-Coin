extends CharacterBody2D

const SPEED = 150.0
var direction = Vector2.DOWN
var is_active = true

func _ready() -> void:
	velocity = Vector2(-1, 1).normalized() * SPEED

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
		if collision:
			rotation += 1
			velocity = velocity.bounce(collision.get_normal())
			position += collision.get_normal() * 1.5
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
		if(velocity .y > 0 and velocity.y < 50):
			velocity.y = -50
		if abs(velocity.x) < 50:
			velocity.x = 50 if velocity.x >= 0 else -50
		velocity = velocity.normalized() * SPEED
