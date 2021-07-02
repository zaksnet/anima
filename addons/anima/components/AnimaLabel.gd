tool
class_name AnimaLabel
extends Control

const Align = {
	LEFT = HALIGN_LEFT,
	CENTER = HALIGN_CENTER,
	RIGHT = HALIGN_RIGHT,
}

const VAlign = {
	TOP = VALIGN_TOP,
	CENTER = VALIGN_CENTER,
	BOTTOM = VALIGN_BOTTOM,
}

export (String) var _label = 'AnimaLabel' setget set_label
export (Font) var _font setget set_font
export (Align) var _align = Align.CENTER setget set_align
export (VAlign) var _valign = VAlign.CENTER setget set_valign
export (Color) var _font_color = Color.white setget set_font_color
export (Vector2) var _text_offset = Vector2.ZERO setget set_text_offset_px
export (Vector2) var _text_scale = Vector2(1, 1) setget set_text_scale
export (Vector2) var _container_scale = Vector2(1, 1) setget set_container_scale

func _ready():
	if not is_connected("item_rect_changed", self, '_on_AnimaLabel_item_rect_changed'):
		connect("item_rect_changed", self, '_on_AnimaLabel_item_rect_changed')

	set_font(_font)

func _process(_delta):
	if Engine.editor_hint:
		update()

func _draw() -> void:
	$Viewport/Label.rect_size = rect_size
	$Viewport/Label.rect_position = Vector2.ZERO

	var size = $Viewport/Label.rect_size
	$Viewport.size = size

	var source_position = - _text_offset
	var source_size = rect_size * Vector2(1, _text_scale.y)
	var final_position = Vector2.ZERO

	source_position.y -= (rect_size.y - size.y) / 2

	draw_texture_rect_region($Viewport.get_texture(), Rect2(final_position, rect_size), Rect2(source_position, source_size))

func set_label(label: String) -> void:
	_label = label

	if get_child_count():
		$Viewport/Label.text = label

	update()

func get_children() -> Array:
	return []

func set_font(font: Font) -> void:
	_font = font

	if get_child_count():
		$Viewport/Label.add_font_override("font", _font)

	if _font and not _font.is_connected("changed", self, '_update_font'):
		_font.connect("changed", self, '_update_font')

func set_align(align: int) -> void:
	_align = align

	if get_child_count():
		$Viewport/Label.align = align
	update()

func set_valign(valign: int) -> void:
	_valign = valign

	if get_child_count():
		$Viewport/Label.valign = valign

	update()

func set_font_color(color: Color) -> void:
	_font_color = color

	if get_child_count():
		$Viewport/Label.add_color_override("font_color", color)

	update()

func set_text_offset_px(offset: Vector2) -> void:
	_text_offset = offset

	update()

func set_text_scale(scale: Vector2) -> void:
	_text_scale = scale

	update()

func set_container_scale(scale: Vector2) -> void:
	_container_scale = scale

	set_size(rect_size)
	
	update()

func set_size(size: Vector2, _keep_margin := false) -> void:
	var new_size: Vector2 = size * _container_scale

	rect_size = new_size
	rect_min_size = new_size

func _update_font() -> void:
	update()

func _on_AnimaLabel_item_rect_changed():
	update()
