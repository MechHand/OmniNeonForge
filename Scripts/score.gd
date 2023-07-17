extends Node

var score = 0
var highscore = 0

func _process(delta):
	if score > highscore:
		highscore = score
		
func gain_score(amount):
	score = score + amount

func reset_score():
	score = 0
