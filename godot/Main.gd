extends Control

const W := 7
const H := 5
const CELL_MIN := Vector2(78, 78)
const BG := Color("080b12")
const PANEL := Color("101722")
const CYAN := Color("71f4e0")
const GOLD := Color("ffc878")
const MUTED := Color("9bacbb")

var levels: Array[Dictionary] = []
var level_index := 0
var cells: Array[Dictionary] = []
var cell_buttons: Array[Button] = []
var moves := 0
var level_label: Label
var move_label: Label
var status_label: Label
var board_grid: GridContainer
var send_button: Button
var next_button: Button

func _ready() -> void:
	_build_levels()
	_load_progress()
	_build_ui()
	_load_level()

func _build_levels() -> void:
	levels = [
		_make_level("01 · Earth transit", Vector2i(0, 2), Vector2i(5, 2), [
			{ "at": Vector2i(1, 2), "dir": 0 }, { "at": Vector2i(2, 2), "dir": 0 },
			{ "at": Vector2i(3, 2), "dir": 0 }, { "at": Vector2i(3, 3), "dir": 2 },
			{ "at": Vector2i(2, 3), "dir": 2 }, { "at": Vector2i(1, 3), "dir": 1 },
			{ "at": Vector2i(1, 4), "dir": 0 }, { "at": Vector2i(2, 4), "dir": 0 },
			{ "at": Vector2i(3, 4), "dir": 0 }, { "at": Vector2i(4, 4), "dir": 0 },
			{ "at": Vector2i(5, 4), "dir": 3 }, { "at": Vector2i(5, 3), "dir": 3 }
		], [Vector2i(4, 1)]),
		_make_level("02 · Mantle drift", Vector2i(0, 1), Vector2i(6, 3), [
			{ "at": Vector2i(1, 1), "dir": 0 }, { "at": Vector2i(2, 1), "dir": 0 },
			{ "at": Vector2i(2, 2), "dir": 0 }, { "at": Vector2i(3, 2), "dir": 0 },
			{ "at": Vector2i(4, 2), "dir": 0 }, { "at": Vector2i(4, 3), "dir": 0 },
			{ "at": Vector2i(5, 3), "dir": 0 }
		], [Vector2i(3, 1)]),
		_make_level("03 · Core crossing", Vector2i(0, 4), Vector2i(6, 0), [
			{ "at": Vector2i(1, 4), "dir": 0 }, { "at": Vector2i(2, 4), "dir": 2 },
			{ "at": Vector2i(2, 3), "dir": 0 }, { "at": Vector2i(3, 3), "dir": 3 },
			{ "at": Vector2i(3, 2), "dir": 0 }, { "at": Vector2i(4, 2), "dir": 3 },
			{ "at": Vector2i(4, 1), "dir": 0 }, { "at": Vector2i(5, 1), "dir": 3 },
			{ "at": Vector2i(5, 0), "dir": 0 }
		], [Vector2i(1, 2), Vector2i(4, 4)])
	]

func _make_level(title: String, source: Vector2i, target: Vector2i, relays: Array, fields: Array) -> Dictionary:
	var board: Array[Dictionary] = []
	for i in range(W * H):
		board.append({ "type": "empty", "dir": 0, "lit": false })
	board[_index(source)] = { "type": "source", "dir": 0, "lit": false }
	board[_index(target)] = { "type": "target", "dir": 0, "lit": false }
	for relay in relays:
		board[_index(relay.at)] = { "type": "relay", "dir": relay.dir, "lit": false }
	for field in fields:
		board[_index(field)] = { "type": "field", "dir": 0, "lit": false }
	return { "title": title, "source": source, "cells": board }

func _index(point: Vector2i) -> int:
	return point.y * W + point.x

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var backdrop := ColorRect.new()
	backdrop.color = BG
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var outer := CenterContainer.new()
	outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(outer)
	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", 22)
	outer.add_child(layout)

	var main_panel := _panel()
	main_panel.custom_minimum_size = Vector2(760, 0)
	layout.add_child(main_panel)
	var main_column := VBoxContainer.new()
	main_column.add_theme_constant_override("separation", 14)
	main_panel.add_child(main_column)

	var eyebrow := _label("SIGNAL SCIENCE  /  FIELD TEST", 12, CYAN)
	main_column.add_child(eyebrow)
	main_column.add_child(_label("PHASELINE", 42, Color("edf5f7")))
	level_label = _label("", 14, MUTED)
	main_column.add_child(level_label)
	board_grid = GridContainer.new()
	board_grid.columns = W
	board_grid.add_theme_constant_override("h_separation", 8)
	board_grid.add_theme_constant_override("v_separation", 8)
	main_column.add_child(board_grid)
	for i in range(W * H):
		var cell := Button.new()
		cell.custom_minimum_size = CELL_MIN
		cell.focus_mode = Control.FOCUS_ALL
		cell.add_theme_font_size_override("font_size", 30)
		cell.pressed.connect(_on_cell_pressed.bind(i))
		cell_buttons.append(cell)
		board_grid.add_child(cell)

	var controls := HBoxContainer.new()
	controls.add_theme_constant_override("separation", 10)
	main_column.add_child(controls)
	status_label = _label("ROTATE THE MISALIGNED RELAY, THEN SEND THE PULSE", 12, MUTED)
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls.add_child(status_label)
	move_label = _label("MOVES 0", 12, MUTED)
	controls.add_child(move_label)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	main_column.add_child(actions)
	var reset_button := _button("Reset")
	reset_button.pressed.connect(_load_level)
	actions.add_child(reset_button)
	send_button = _button("Send pulse")
	send_button.pressed.connect(_send_pulse)
	actions.add_child(send_button)
	next_button = _button("Next signal →")
	next_button.pressed.connect(_next_level)
	next_button.hide()
	actions.add_child(next_button)

	var side := _panel()
	side.custom_minimum_size = Vector2(270, 0)
	layout.add_child(side)
	var notes := VBoxContainer.new()
	notes.add_theme_constant_override("separation", 16)
	side.add_child(notes)
	notes.add_child(_label("MISSION", 14, Color("edf5f7")))
	notes.add_child(_label("Carry a neutrino message through the planet. Rotate relay arrows to guide the pulse to its receiver.", 14, MUTED, true))
	notes.add_child(_label("CONTROLS", 14, Color("edf5f7")))
	notes.add_child(_label("Click a relay to rotate clockwise. Enter sends the pulse. R resets the puzzle.", 14, MUTED, true))
	notes.add_child(_label("FIELD NOTE", 14, Color("edf5f7")))
	notes.add_child(_label("In this fictional puzzle model, a dense mantle field absorbs a pulse that crosses it.", 14, MUTED, true))

func _panel() -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL
	style.border_color = Color("273443")
	style.set_border_width_all(1)
	style.set_corner_radius_all(14)
	style.set_content_margin_all(22)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _label(text: String, size: int, color: Color, wrap := false) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	return label

func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 44
	button.add_theme_font_size_override("font_size", 14)
	return button

func _load_level() -> void:
	if levels.is_empty():
		return
	cells = []
	for cell in levels[level_index].cells:
		cells.append(cell.duplicate(true))
	moves = 0
	next_button.hide()
	send_button.show()
	status_label.text = "ROTATE THE MISALIGNED RELAY, THEN SEND THE PULSE"
	status_label.add_theme_color_override("font_color", MUTED)
	level_label.text = "%s   /   %02d OF %02d" % [levels[level_index].title, level_index + 1, levels.size()]
	_render_board()

func _render_board() -> void:
	move_label.text = "MOVES %d" % moves
	for i in range(cells.size()):
		var cell: Dictionary = cells[i]
		var button := cell_buttons[i]
		var tile_type: String = cell.type
		button.disabled = tile_type != "relay"
		button.text = "" if tile_type == "empty" else _symbol(cell)
		var style := StyleBoxFlat.new()
		style.set_corner_radius_all(9)
		style.set_border_width_all(1)
		style.bg_color = Color("111c28")
		style.border_color = Color("304454")
		if tile_type == "source":
			style.bg_color = Color("122b32")
			style.border_color = CYAN
		elif tile_type == "target":
			style.bg_color = Color("2b2418")
			style.border_color = GOLD
		elif tile_type == "field":
			style.bg_color = Color("25151f")
			style.border_color = Color("704553")
		elif cell.lit:
			style.bg_color = Color("163332")
			style.border_color = CYAN
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style)
		button.add_theme_stylebox_override("pressed", style)
		button.add_theme_color_override("font_color", CYAN if tile_type in ["source", "relay"] else GOLD)

func _symbol(cell: Dictionary) -> String:
	match cell.type:
		"source": return "◉"
		"target": return "◎"
		"field": return "×"
		"relay": return ["→", "↓", "←", "↑"][cell.dir]
	return ""

func _on_cell_pressed(index: int) -> void:
	if cells[index].type != "relay":
		return
	cells[index].dir = (cells[index].dir + 1) % 4
	cells[index].lit = false
	moves += 1
	status_label.text = "RELAY ROTATED · SEND WHEN READY"
	_render_board()

func _send_pulse() -> void:
	for cell in cells:
		cell.lit = false
	var point: Vector2i = levels[level_index].source
	var direction := Vector2i.RIGHT
	var visited: Dictionary = {}
	var received := false
	for _step in range(W * H * 2):
		if point.x < 0 or point.x >= W or point.y < 0 or point.y >= H:
			break
		var index := _index(point)
		if visited.has(index):
			break
		visited[index] = true
		var cell: Dictionary = cells[index]
		cell.lit = true
		if cell.type == "target":
			received = true
			break
		if cell.type == "field":
			break
		if cell.type == "relay":
			direction = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP][cell.dir]
		point += direction
	_render_board()
	if received:
		status_label.text = "SIGNAL RECEIVED · ROUTE STABLE"
		status_label.add_theme_color_override("font_color", CYAN)
		send_button.hide()
		if level_index + 1 < levels.size():
			next_button.show()
		else:
			status_label.text = "ALL FIELD TESTS COMPLETE · SIGNAL RESTORED"
		_save_progress(level_index + 1)
	else:
		status_label.text = "PULSE LOST · ADJUST THE RELAYS"
		status_label.add_theme_color_override("font_color", Color("ff647c"))

func _next_level() -> void:
	if level_index + 1 >= levels.size():
		return
	level_index += 1
	_load_level()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		_send_pulse()
	elif event.keycode == KEY_R:
		_load_level()

func _save_progress(unlocked_level: int) -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "unlocked_level", mini(unlocked_level, levels.size() - 1))
	config.save("user://progress.cfg")

func _load_progress() -> void:
	var config := ConfigFile.new()
	if config.load("user://progress.cfg") == OK:
		level_index = clampi(int(config.get_value("progress", "unlocked_level", 0)), 0, levels.size() - 1)
