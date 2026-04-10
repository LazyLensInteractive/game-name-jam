extends Node

var object_health = []
var object_exp = []
var object_money = []
var exp_multi = 1
var money_multi = 1
var player_exp = 0
var player_money: int = 0
var player_strength = 1 
#redid this function to be able tp handle more than one multimesh its also simplified
func object_data(count: int):
	for i in range(count):
		var random = randf()
		if random < 2:
			object_health.append(1)
			object_exp.append(5 * exp_multi)
			object_money.append(1 * money_multi)
		else:
			object_health.append(3)
			object_exp.append(15 * exp_multi)
			object_money.append(5 * money_multi)

func data_calc(i: int):
	player_money += object_money[i]
	player_exp += object_exp[i]
