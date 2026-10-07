extends SceneTree

const EXPECTED_SOLUTIONS: Array = [
	[Vector2i(3, 2)],
	[Vector2i(2, 1), Vector2i(4, 2)],
	[Vector2i(2, 4)],
]

func _initialize() -> void:
	call_deferred("_run_playtest")

func _run_playtest() -> void:
	await process_frame
	var game = load("res://Main.tscn").instantiate()
	root.add_child(game)
	await process_frame

	if not _check(game.levels.size() == EXPECTED_SOLUTIONS.size(), "Expected three playable puzzles"):
		return
	for level in range(EXPECTED_SOLUTIONS.size()):
		game._send_pulse()
		if not _check(game.status_label.text.begins_with("PULSE LOST"), "Puzzle %d must start unsolved" % (level + 1)):
			return

		for relay_position in EXPECTED_SOLUTIONS[level]:
			game._on_cell_pressed(game._index(relay_position))
		game._send_pulse()
		var solved := game.status_label.text.contains("SIGNAL RECEIVED") or game.status_label.text.contains("ALL FIELD TESTS COMPLETE")
		if not _check(solved, "Puzzle %d should solve using its authored relay route" % (level + 1)):
			return
		if level < EXPECTED_SOLUTIONS.size() - 1:
			game._next_level()

	if not _check(game.status_label.text.contains("ALL FIELD TESTS COMPLETE"), "Campaign should complete after the third puzzle"):
		return
	print("Automated playtest passed: all three puzzles solved and progression completed.")
	quit(0)

func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("Automated playtest failed: " + message)
	quit(1)
	return false
