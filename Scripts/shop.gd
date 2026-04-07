extends Area3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var panel: Panel = $"../ShopUI/Panel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_body_exited(body: Node3D) -> void:
	if body == player:
		shop_close()
		print("player out of area")
func _on_body_entered(body: Node3D) -> void:
	if body == player:
		shop_open()
		print("player in area")
func shop_open():
	panel.position = Vector2(50, 70)
func shop_close():
	panel.position = Vector2(5000, 7000)


func _on_button_pressed() -> void:
	upgrade_button_pressed("speed")
#holds shop items and the cost 
var shop_items = {
	"speed": {
		1: {"cost": 20, "exp_needed": 0},
		2: {"cost": 50, "exp_needed": 0},
		3: {"cost": 80, "exp_needed": 0}
	},
	"boost": {
		1: {"cost": 20, "exp_needed": 0}
	},
	"range": {
		1: {"cost": 20, "exp_needed": 0}
	},
	"bomb": {
		1: {"cost": 20, "exp_needed": 0}
	},
	"strength": {
		1: {"cost": 20, "exp_needed": 0}
	},
	"roller": {
		1: {"cost": 20, "exp_needed": 0}
	}
}
#holds player current upgrade status 0 meaning not bought anything and or not active if need to be bought first
var player_upgrades = {
	"strength": 0,
	"speed": 0,
	"range": 0,
	"bomb": 0,
	"boost": 0,
	"roller": 0
}
func upgrade_button_pressed(type: String) -> void:
	var current_level = player_upgrades[type] #gets the player current level of type from the button press (call it with the type var)
	var next_level = current_level + 1 #adds a level
	if shop_items[type].has(next_level): #checks if the type has a next value if not it assumes max level
		var item_data = shop_items[type][next_level]
		var price = item_data["cost"] #i feel like this is self explanitory at this point and im getting tired these coments are takeing me out
		if GlobalData.player_money >= price:
			GlobalData.player_money -= price
			player_upgrades[type] = next_level
			print("upgraded wow so cool")
			#shop_text_update()   ignore for now but just make updating ui tomorrow 
		else:
			print("Get your money up lil bro")
	else:
		print("no levels remain")
