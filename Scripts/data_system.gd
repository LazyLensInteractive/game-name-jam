extends Node

class Player:
	var exp: int = 0
	var money: int = 0
	var strength: int = 4
	var upgrades: Dictionary = {
		"strength": 0,
		"speed": 0,
		"range": 0,
		"bomb": 0,
		"boost": 0,
		"roller": 0
	}

	func _init() -> void:
		pass

	func add_item(item: Item) -> void:
		exp += item.exp
		money += item.money

class PhysicalItem:
	var item: Item
	var transform: Transform3D

	func _init(p_item: Item, p_transform: Transform3D) -> void:
		item = p_item
		transform = p_transform

class Item:
	var health: int
	var exp: int
	var money: int

	func _init(p_health: int, p_exp: int, p_money: int) -> void:
		health = p_health
		exp = p_exp
		money = p_money

var player: Player

func _ready() -> void:
	player = Player.new()
