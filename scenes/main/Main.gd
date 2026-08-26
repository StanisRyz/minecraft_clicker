extends Control

const ClickerScreenScene = preload("res://scenes/game/ClickerScreen.tscn")

var _clicker_screen: Node = null


func _ready() -> void:
	_clicker_screen = ClickerScreenScene.instantiate()
	_clicker_screen.name = "ClickerScreen"
	add_child(_clicker_screen)
	_begin_startup_wait()


func _begin_startup_wait() -> void:
	if not is_instance_valid(_clicker_screen) or not _clicker_screen.has_signal("startup_completed"):
		push_warning("Main: ClickerScreen startup_completed not found — calling game_ready as fallback")
		await get_tree().process_frame
		Platform.game_ready()
		return
	if _clicker_screen.has_method("is_startup_completed") and _clicker_screen.is_startup_completed():
		if _clicker_screen.has_method("notify_yandex_game_ready"):
			_clicker_screen.notify_yandex_game_ready()
		else:
			Platform.game_ready()
		return
	await _clicker_screen.startup_completed
	if _clicker_screen.has_method("notify_yandex_game_ready"):
		_clicker_screen.notify_yandex_game_ready()
	else:
		Platform.game_ready()
