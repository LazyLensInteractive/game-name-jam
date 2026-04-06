extends Node

var object_health = []
var object_exp = []
var object_money = []
var exp_multi = 1
var money_multi = 1
var player_exp = 0
var player_money = 0
var player_strength = 5

func object_data(count: int): #this function should only be called once at ready from the node spawning script but clears are there just in case something weird happens or we want levels
	object_health.clear()
	object_exp.clear()
	object_money.clear()
	
	for i in range(count):
		var random = randf()
		if random < .8:
			object_health.append(1)
			object_exp.append(5 * exp_multi)
			object_money.append(1 * money_multi)
		else:
			object_health.append(3)
			object_exp.append(15 * exp_multi)
			object_money.append(5 * money_multi)
func data_calc(i: int):
	var earned_money = object_money[i]
	var earned_exp = object_exp[i]
	player_money += earned_money
	player_exp += earned_exp
	print("Killed Goober ", i, " | Gained: $", earned_money, " | Total: $", player_money)
