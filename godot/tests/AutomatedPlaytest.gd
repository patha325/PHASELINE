extends SceneTree

const DIRECTIONS: Array[Vector2i] = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]

func _initialize() -> void:
	call_deferred("_run_playtest")

func _run_playtest() -> void:
	await process_frame
	var game = load("res://Main.tscn").instantiate()
	root.add_child(game)
	await process_frame

	if not _check(game.levels.size() == 3, "Expected three playable puzzles"):
		return
	# Ignore any progress file from a previous local run so CI always starts at puzzle 1.
	game.level_index = 0
	game._load_level()
	for level in range(game.levels.size()):
		game._send_pulse()
		if not _check(game.status_label.text.begins_with("PULSE LOST"), "Puzzle %d must start unsolved" % (level + 1)):
			return

		var routes: Array = []
		var visited: Dictionary = {}
		var choices: Array = []
		_search_routes(game, game.levels[level].source, visited, choices, routes)
		if not _check(not routes.is_empty(), "Puzzle %d has no route to its receiver" % (level + 1)):
			return

		var best_route: Array = []
		var best_clicks := 2147483647
		for route in routes:
			var click_count := 0
			for choice in route:
				var current_direction: int = game.cells[choice.index].dir
				click_count += (choice.direction - current_direction + 4) % 4
			if click_count < best_clicks:
				best_clicks = click_count
				best_route = route
		if not _check(best_clicks > 0, "Puzzle %d must not start solved" % (level + 1)):
			return

		for choice in best_route:
			while game.cells[choice.index].dir != choice.direction:
				game._on_cell_pressed(choice.index)
		game._send_pulse()
		var solved: bool = game.status_label.text.contains("SIGNAL RECEIVED") or game.status_label.text.contains("ALL FIELD TESTS COMPLETE")
		if not _check(solved, "Puzzle %d should solve using the solver-discovered route" % (level + 1)):
			return
		if level < game.levels.size() - 1:
			game._next_level()

	if not _check(game.status_label.text.contains("ALL FIELD TESTS COMPLETE"), "Campaign should complete after the third puzzle"):
		return

	# Exercise unpredictable relay rotations, then confirm Reset restores a clean puzzle.
	game.level_index = 0
	game._load_level()
	var rng := RandomNumberGenerator.new()
	rng.seed = 20261008
	for _attempt in range(12):
		var index: int = rng.randi_range(0, game.cells.size() - 1)
		if game.cells[index].type == "relay":
			game._on_cell_pressed(index)
	game._send_pulse()
	game._load_level()
	if not _check(game.moves == 0, "Reset should clear the move count"):
		return
	for index in range(game.cells.size()):
		if not _check(game.cells[index].dir == game.levels[0].cells[index].dir, "Reset should restore every relay direction"):
			return
	game._send_pulse()
	if not _check(game.status_label.text.begins_with("PULSE LOST"), "Reset should restore puzzle 1 to its unsolved state"):
		return
	print("Automated playtest passed: solver found and played every puzzle, campaign progression completed, and misplay/reset checks passed.")
	quit(0)

func _search_routes(game, point: Vector2i, visited: Dictionary, choices: Array, routes: Array) -> void:
	if point.x < 0 or point.x >= game.W or point.y < 0 or point.y >= game.H:
		return
	var index: int = game._index(point)
	if visited.has(index):
		return
	var cell: Dictionary = game.cells[index]
	if cell.type == "empty" or cell.type == "field":
		return
	visited[index] = true
	if cell.type == "target":
		routes.append(choices.duplicate(true))
	elif cell.type == "relay":
		for direction in range(DIRECTIONS.size()):
			choices.append({"index": index, "direction": direction})
			_search_routes(game, point + DIRECTIONS[direction], visited, choices, routes)
			choices.pop_back()
	elif cell.type == "source":
		_search_routes(game, point + Vector2i.RIGHT, visited, choices, routes)
	visited.erase(index)

func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("Automated playtest failed: " + message)
	quit(1)
	return false
