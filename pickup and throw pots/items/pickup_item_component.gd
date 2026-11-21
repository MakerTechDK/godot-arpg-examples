class_name PickupItemC extends Area2D

signal thrown
signal put_down


@export var throw_length: int = 48
@export var throw_duration: float = 0.3

@onready var parent: Node2D = get_parent()

var move_tween: Tween


func pickup(collector: Node2D) -> void:
	if !parent: return
	
	parent.reparent(collector)
	parent.position = Vector2(0,0)
	
	
func throw(direction: Vector2, y_base: int) -> void:
	var current_scene = get_tree().current_scene
	parent.reparent(current_scene)
	
	prepare_throw()
	
	var end_position = parent.global_position + direction.normalized() * throw_length
	if direction.y == 0: end_position.y = y_base
	else: direction.y += 8
	
	#end_position.y = int(end_position.y + 16) / 16 * 16
	
	move_tween = create_tween()
	move_tween.tween_property(parent, "global_position", end_position, throw_duration)
	
	await move_tween.finished
	just_placed()


func prepare_throw() -> void:
	thrown.emit()
	
	
func just_placed() -> void:
	put_down.emit()
	
	var current_scene = get_tree().current_scene
	if current_scene.has_method("add_interactable"):
		current_scene.add_interactable(parent)
	else: parent.queue_free()


func _on_hit_box_hit_occured() -> void:
	move_tween.stop()
