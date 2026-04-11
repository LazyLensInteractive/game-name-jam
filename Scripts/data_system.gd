extends Node

var player: Player = Player.new()

class Player:
	var exp := 0
	var money: int = 0
	var strength := 1 

	var upgrades = {
		"strength": 0,
		"speed": 0,
		"range": 0,
		"bomb": 0,
		"boost": 0,
		"roller": 0
	}
	
	func _init() -> void:
		pass
	
	func add_item(item: Item):
		exp += item.exp
		money += item.money

class PhysicalItem:
	var item: Item
	var transform: Transform3D
	
	func _init(item: Item, transform: Transform3D) -> void:
		self.item = item
		self.transform = transform

class Item:
	var health: int
	var exp: int
	var money: int
	
	func _init(health, exp, money) -> void:
		self.health = health
		self.exp = exp
		self.money = money
>>>>>>> f5dd66e (Cleaned up region code)
