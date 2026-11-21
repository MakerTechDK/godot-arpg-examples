class_name Player extends CharacterBody2D


@export var speed: int = 35
@onready var animations = $AnimationPlayer


var last_anim_direction: String = "down"
var action_string: String = ""

enum State{NORMAL, BLOCKED}
var state: State = State.NORMAL


func handle_input():
	if state == State.BLOCKED: return
	
	var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move_direction*speed
	
	
func update_animation():
	if state == State.BLOCKED: return
	
	if velocity.length() == 0:
		animations.play("idle_" + action_string + last_anim_direction)
	else:
		var direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
	
		animations.play("walk_" + action_string + direction)
		last_anim_direction = direction


func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
