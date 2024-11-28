# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/cyclopsLevelBuilder
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
extends CyclopsTool
class_name ToolUvMove

enum ToolState { READY }
var tool_state:ToolState = ToolState.READY

var settings:ToolMoveUvSettings = ToolMoveUvSettings.new()

var mouse_hover_pos:Vector2

var zoom_wheel_amount:float = 1.2

func is_uv_tool():
	return true
	
func _get_tool_name()->String:
	return "Move UVs"

func _get_tool_icon()->Texture2D:
	#return preload("res://addons/cyclops_level_builder/art/icons/move.svg")
	var tag_:ToolTag = load("res://addons/cyclops_level_builder/data/tool_tags/tool_tag_move.tres")
	return tag_.icon

func _get_tool_tooltip()->String:
	return "Move UVs"

#func _get_tool_properties_editor()->Control:
	#var ed:ToolMoveSettingsEditor = preload("res://addons/cyclops_level_builder/tools/tool_move_settings_editor.tscn").instantiate()
	#
	#ed.settings = settings
	#
	#return ed

func _can_handle_object(node:Node)->bool:
	#print("_can_handle_object -- uv move")
	#return node is CyclopsBlock
	return true

func _draw_tool(viewport_camera:Camera3D):
	return
	

func _gui_input(viewport_camera:Camera3D, event:InputEvent)->bool:
	if !builder:
		return false
	
	var view:ViewUvEditor = builder.view_uv_editor
	var uv_ed:UvEditor = view.get_uv_editor()
	
	
	
	if event is InputEventMouseButton:

		var e:InputEventMouseButton = event
		if e.button_index == MOUSE_BUTTON_LEFT:

			if e.is_pressed():
				
				
				pass

		elif e.button_index == MOUSE_BUTTON_WHEEL_UP:
			if e.pressed:
#				print("uv_move wheel up")
				
#				var uv_to_view_xform:Transform2D = uv_ed.get_uv_to_viewport_xform()
				var view_xform:Transform2D = uv_ed.get_view_transform()
				
				var new_xform:Transform2D
#				print("uv_to_view_xform ", uv_to_view_xform)
				new_xform = new_xform.translated_local(e.position)
				new_xform = new_xform.scaled_local(Vector2(zoom_wheel_amount, zoom_wheel_amount))
				new_xform = new_xform.translated_local(-e.position)
				new_xform = new_xform * view_xform * uv_ed.proj_transform
				
				uv_ed.proj_transform = view_xform.affine_inverse() * new_xform

				return true

		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if e.pressed:
				var view_xform:Transform2D = uv_ed.get_view_transform()
				
				var new_xform:Transform2D
#				print("uv_to_view_xform ", uv_to_view_xform)
				new_xform = new_xform.translated_local(e.position)
				new_xform = new_xform.scaled_local(Vector2(1 / zoom_wheel_amount, 1 / zoom_wheel_amount))
				new_xform = new_xform.translated_local(-e.position)
				new_xform = new_xform * view_xform * uv_ed.proj_transform
				
				uv_ed.proj_transform = view_xform.affine_inverse() * new_xform
				
				return true

	elif event is InputEventMouseMotion:
		var e:InputEventMouseMotion = event
		
		mouse_hover_pos = e.position

	return false


func _activate(builder:CyclopsLevelBuilder):
	super._activate(builder)

func _deactivate():
	super._deactivate()
	
	#var global_scene:CyclopsGlobalScene = builder.get_global_scene()
	#global_scene.set_custom_gizmo(null)
	pass

	
