extends Node2D

export (float) var offset_y = 100.0
export (float) var margin = 30.0

var scores = []
var rank = ["1st", "2nd", "3rd"]

# ボタン押下でタイトルシーンへ
func _unhandled_input(event):
	if event.is_pressed():
		var title = load("res://scenes/Title.tscn")
		var _e = get_tree().change_scene_to(title)

# leaderboardの表示
# テンプレートの$Scoreを複製して中身を変えていく
# $Scoreノードは最後に消す
func _ready():
	for i in Score.scores.size(): 
		scores.push_back($Score.duplicate())
		var _rank = rank[i] if i < 3 else "%sth" % (i + 1)
		var _score = Score.scores[i]
		var _name = Score.names[i]
		scores[i].get_node("Rank").bbcode_text = "[right]%s[/right]" % _rank
		scores[i].get_node("Score").bbcode_text = "[right]%s[/right]" % _score
		scores[i].get_node("Name").bbcode_text = _name
		scores[i].position.y = margin * i + offset_y
		add_child(scores[i])

	$Score.queue_free()
