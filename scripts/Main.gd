extends Node2D

export (Vector2) var block_number
export (float) var pad_limit_l = 20
export (float) var pad_limit_r = 280
const MARGIN = 1

var block_count = 0
var is_finish = false
var score = 0

onready var player := $Player
onready var ball := $Ball
onready var pad := $Pad
onready var coin := preload("res://scenes/Coin.tscn")

# esc押下でタイトルへ、ゲーム終了後は何か押されたらleaderboardへ。
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		var _e =get_tree().change_scene_to(load("res://scenes/Title.tscn"))
	if is_finish && event is InputEvent && event.is_pressed():
		var _e = get_tree().change_scene_to(load("res://scenes/LeaderBoard.tscn"))

# ゲーム開始の時のいろいろ
func _ready():
	is_finish = false
	$GameOver.visible = false
	$ScoreResult.visible = false
	var _e = ball.connect("hit", self, "_on_ball_hit")
	_e = player.connect("get_coin", self, "_on_get_coin")
	_set_blocks()
	_set_high_score()
	score = 99999.9
	$Start.play()
	_processing(false)
	yield($Start, "finished")
	_processing(true)

# ボールのposition.xにpadを連動
func _physics_process(delta):
	_time_count(delta)
	pad.position.x = clamp(ball.position.x, pad_limit_l, pad_limit_r)

# ゲーム開始時にブロックを複製しながら並べる
func _set_blocks():
	var _origin = $Block.position
	var _size = $Block.scale
	for y in block_number.y:
		for x in block_number.x:
			var _b = $Block.duplicate()
			_b.position = Vector2((_size.x + MARGIN) * x, (_size.y + MARGIN) * y) + _origin
			add_child(_b)
			block_count += 1
	$Block.queue_free()

# delta_timeを見て、スコアを減らす
func _time_count(_delta):
	score -= int(_delta * 1000)
	$Score.text = "SCORE: %s" % int(score)

# コインを取ったらマイナスのdelta_timeを送ってスコアを増やす
func _on_get_coin():
	_time_count(-3)


# ボールが当たったobjがblockグループだったらコインを出してblockを消す
# blockの数が0になったらクリア
func _on_ball_hit(_node, _pos):
	var _groups = _node.get_groups()
	if _groups.has("block"):
		block_count -= 1
		_put_coins()
		if block_count <= 0:
			_game_clear()
		_node.queue_free()

# コインを6個出す。
func _put_coins():
	for i in 6:
		var _coin = coin.instance()
		var _rad = PI / 3 * i
		var _velocity = Vector2(sin(_rad), cos(_rad))
		_coin.initialize(ball.position, _velocity)
		add_child(_coin)

# ゲームクリア時のいろいろ
func _game_clear():
	set_physics_process(false)
	yield(get_tree().create_timer(2.0), "timeout")
	_set_high_score()
	_processing(false)
	yield(get_tree().create_timer(1.0), "timeout")
	$Clear.play()
	_game_over()
	yield(get_tree().create_timer(2.0), "timeout")
	is_finish = true
	set_process_unhandled_input(true)

# ゲームクリア時のいろいろのヘルパ
func _game_over():
	$GameOver.visible = true
	$ScoreResult.visible = true
	var _score = int(score)
	if Score.get_high_score() == _score:
		$ScoreResult.bbcode_text = "[rainbow]score: %s[/rainbow]" % _score
	else:
		$ScoreResult.bbcode_text = "score: %s" % _score

# ゲームの状況でobjectを止めたり動かしたりする
func _processing(b):
	ball.set_physics_process(b)
	player.set_process(b)
	set_physics_process(b)

# ゲーム画面のハイスコアの更新
func _set_high_score():
	Score.set_leader_board(score)
	if score > Score.get_high_score():
		Score.set_high_score(score)
	$HighScore.text = "HIGHSCORE: %s" % Score.high_score
