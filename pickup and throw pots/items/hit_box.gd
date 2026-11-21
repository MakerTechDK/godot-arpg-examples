class_name HitBox extends Area2D

signal hit_occured


func _on_body_entered(body: Node2D) -> void:
	if body is Player: return
	#damage body
	hit_occured.emit()
