extends Node


var scores = [
	500000,
	400000,
	300000,
	200000,
	100000,
	80000,
	60000,
	40000,
	20000,
	0
]

var names = [
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
	"someone",
]

var high_score = 0 

# Scoreがランク内だったら書き換える
func set_leader_board(_s):
	var _score = int(_s)
	for i in scores.size():
		if _score >= scores[i]:
			scores.insert(i, _score)
			names.insert(i, "you")
			scores.pop_back()
			names.pop_back()
			return

func set_high_score(_s):
	high_score = int(_s)

func get_high_score():
	return high_score
