extends Node2D


@onready var interactables_tilemap_layer: TileMapLayer = $Tilemaps/Interactables


func add_interactable(item: Node2D) -> void:
	item.reparent(interactables_tilemap_layer)
