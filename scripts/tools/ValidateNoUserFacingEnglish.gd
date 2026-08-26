## Flags likely player-visible English phrases in the core runtime presentation paths.
## Internal ids, paths, comments, debug logs, and technical abbreviations are ignored.
extends SceneTree

const SCAN_FILES: Array[String] = [
	"res://scripts/game/ClickerState.gd",
	"res://scripts/game/presentation/ClickerStatePresentation.gd",
	"res://scripts/game/runtime/ShopRuntime.gd",
	"res://scenes/ui/PartnerSkillPopup.gd",
	"res://scenes/ui/UpgradeSkillPopup.gd",
]
const ALLOWED_TECHNICAL_TEXT: Array[String] = ["DPS", "HP", "CD"]


func _init() -> void:
	var findings: Array[String] = []
	for path: String in SCAN_FILES:
		_scan_file(path, findings)
	if findings.is_empty():
		print("ValidateNoUserFacingEnglish: OK")
		quit(0)
	for finding: String in findings:
		print("ERROR: " + finding)
	quit(1)


func _scan_file(path: String, findings: Array[String]) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		findings.append("cannot read " + path)
		return
	var line_number: int = 0
	while not file.eof_reached():
		var line: String = file.get_line()
		line_number += 1
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#") or _is_non_ui_line(stripped):
			continue
		for literal: String in _get_string_literals(stripped):
			if _is_suspicious_english_phrase(literal):
				findings.append("%s:%d: %s" % [path, line_number, literal])
	file.close()


func _is_non_ui_line(line: String) -> bool:
	return line.contains("print(") or line.contains("push_warning(") or line.contains("res://")


func _get_string_literals(line: String) -> Array[String]:
	var literals: Array[String] = []
	var in_literal := false
	var current := ""
	for character: String in line:
		if character == '"':
			if in_literal:
				literals.append(current)
				current = ""
				in_literal = false
			else:
				in_literal = true
		elif in_literal:
			current += character
	return literals


func _is_suspicious_english_phrase(literal: String) -> bool:
	if literal in ALLOWED_TECHNICAL_TEXT or not literal.contains(" "):
		return false
	# User-facing phrases have words separated by spaces. Internal ids use underscores.
	var words: PackedStringArray = literal.split(" ", false)
	var english_word_count: int = 0
	for word: String in words:
		if word.length() >= 3 and _contains_ascii_letters(word):
			english_word_count += 1
	return english_word_count >= 2


func _contains_ascii_letters(text: String) -> bool:
	var run_length: int = 0
	for character: String in text:
		var code: int = character.unicode_at(0)
		if (code >= 65 and code <= 90) or (code >= 97 and code <= 122):
			run_length += 1
			if run_length >= 3:
				return true
		else:
			run_length = 0
	return false
