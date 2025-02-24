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
extends Node
class_name CyclopsTool

var builder:CyclopsLevelBuilder
var tool_owner:Node

#func _init(_editorPlugin:EditorPlugin):
#	editorPlugin = _editorPlugin

func _ready():
	pass

#func _activate(plugin:CyclopsLevelBuilder):
func _activate(tool_owner:Node):
	self.builder = tool_owner if tool_owner is CyclopsLevelBuilder else tool_owner.plugin
	self.tool_owner = tool_owner
	
func _deactivate():
	pass

func _get_tool_id()->String:
	return ""

func _show_in_toolbar()->bool:
	return true

func _get_tool_tooltip()->String:
	return ""

func _get_tool_name()->String:
	return ""

func _get_tool_icon()->Texture2D:
	return null

func _draw_tool(viewport_camera:Camera3D):
	pass

func _get_tool_properties_editor()->Control:
	return null

func _can_handle_object(node:Node)->bool:
	return false

#Work around for new UV editor.  Should be removed when multiple views are implemented.
func is_uv_tool():
	return false

func _gui_input(viewport_camera:Camera3D, event:InputEvent)->bool:
	#print("hotkey  check ", event)
	
	var hotkey_group:HotkeyGroup = builder.config_scene.get_node("Views/View3D/Hotkeys")
	var _action:CyclopsAction = hotkey_group.lookup_action(event)
	if _action:
#		print("found  action  ", _action.name)
		_action._execute(CyclopsActionEvent.new(builder))
		return true
	
	
	#if event is InputEventKey:
		#var e:InputEventKey = event
#
		#if e.keycode == KEY_X:
			#if e.is_pressed():
				##print("cyc tool X")
				#var action:ActionDeleteSelectedBlocks = ActionDeleteSelectedBlocks.new()
				#action.plugin = builder
				#action._execute(CyclopsActionEvent.new(builder))
			#
			#return true
				#
		#if e.keycode == KEY_D:
			#if e.is_pressed():
				#if e.shift_pressed && !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					#
					#var sel_blocks:Array[CyclopsBlock] = builder.get_selected_blocks()
					#if !sel_blocks.is_empty():
											#
##						builder.switch_to_tool(ToolDuplicate.new())
						#builder.switch_to_tool_id(ToolDuplicate.TOOL_ID)
					#
			#return true
	#
	#if event is InputEventMouseButton:
		#var e:InputEventMouseButton = event
		#
		#if e.button_index == MOUSE_BUTTON_MIDDLE:
			#if e.alt_pressed:
				#if e.is_pressed():
					#if builder.get_active_block():
#
						#var origin:Vector3 = viewport_camera.project_ray_origin(e.position)
						#var dir:Vector3 = viewport_camera.project_ray_normal(e.position)
						#
##						var start_pos:Vector3 = origin + builder.block_create_distance * dir
##						var w2l = builder.active_node.global_transform.inverse()
##						var origin_local:Vector3 = w2l * origin
##						var dir_local:Vector3 = w2l.basis * dir
						#
						#var result:IntersectResults = builder.active_node.intersect_ray_closest(origin, dir)
						#if result:
							#var ed_iface:EditorInterface = builder.get_editor_interface()
							#var base_control:Control = ed_iface.get_base_control()
							#
							##viewport_camera
							#var new_cam_origin:Vector3 = result.position + \
								#viewport_camera.global_transform.basis.z * builder.block_create_distance
							#viewport_camera.global_transform.origin = new_cam_origin
					#return true
	
	return false


func focus_on_active_block(viewport_camera:Camera3D, mouse_pos:Vector2):
	if builder.get_active_block():

		var origin:Vector3 = viewport_camera.project_ray_origin(mouse_pos)
		var dir:Vector3 = viewport_camera.project_ray_normal(mouse_pos)
		
		var result:IntersectResults = builder.active_node.intersect_ray_closest(origin, dir)
		if result:
			var ed_iface:EditorInterface = builder.get_editor_interface()
			var base_control:Control = ed_iface.get_base_control()
			
			#viewport_camera
			var new_cam_origin:Vector3 = result.position + \
				viewport_camera.global_transform.basis.z * builder.block_create_distance
			viewport_camera.global_transform.origin = new_cam_origin
	

func to_local(point:Vector3, world_to_local:Transform3D, grid_step_size:float)->Vector3:
	var p_local:Vector3 = world_to_local * point

	return MathUtil.snap_to_grid(p_local, grid_step_size)
	

func calc_empty_space_draw_plane_origin(viewport_camera:Camera3D, draw_plane_point:Vector3 = Vector3.ZERO, draw_plane_normal:Vector3 = Vector3.UP):
	var active_block:CyclopsBlock = builder.get_active_block()
	if !active_block:
		return draw_plane_point
	
	var block_xform:Transform3D = active_block.global_transform
	var vol:ConvexVolume = active_block.control_mesh
	var bounds:AABB = vol.calc_bounds_xform(block_xform)
	var plane:Plane = Plane(draw_plane_normal, bounds.get_center())
	
	var p0:Vector3 = bounds.position
	var p1:Vector3 = bounds.position + bounds.size
	if plane.is_point_over(viewport_camera.global_transform.origin):
		if plane.is_point_over(p0):
			draw_plane_point = p1
		else:
			draw_plane_point = p0
	else:
		if plane.is_point_over(p0):
			draw_plane_point = p0
		else:
			draw_plane_point = p1
				
	return draw_plane_point

func calc_hit_point_empty_space(origin:Vector3, dir:Vector3, viewport_camera:Camera3D = null, base_plane_origin:Vector3 = Vector3.ZERO, drag_floor_normal:Vector3 = Vector3.UP):
		#print("Miss")
		var drag_angle_limit:float = builder.get_global_scene().drag_angle_limit

		var angle_y_axis:float = acos(dir.dot(Vector3.UP))
		if angle_y_axis > PI / 2 - drag_angle_limit && angle_y_axis < PI / 2 + drag_angle_limit:
			#Nearly parallel with ground plane
			if abs(dir.z) > abs(dir.x):
				drag_floor_normal = Vector3.FORWARD
			else:
				drag_floor_normal = Vector3.LEFT

		#print("base_plane_normal ", base_plane_normal)

		var hit_base:Vector3 = MathUtil.intersect_plane(origin, dir, base_plane_origin, drag_floor_normal)
		#print("hit_base 1 ", hit_base)

		if (hit_base - origin).dot(dir) < 0:
			#Hit point is behind camera
			var plane_offset:Vector3 = origin.project(drag_floor_normal)
			base_plane_origin += plane_offset * 2
			hit_base = MathUtil.intersect_plane(origin, dir, base_plane_origin, drag_floor_normal)

		#print("base_plane_origin ", base_plane_origin)
		#print("hit_base ", hit_base)

		var block_drag_p0:Vector3 = builder.get_snapping_manager().snap_point(hit_base, SnappingQuery.new(viewport_camera))
		
		return [block_drag_p0, drag_floor_normal]

func calc_active_block_orthogonal_height(plane_origin:Vector3, drag_floor_normal:Vector3)->float:
	var active_block:CyclopsBlock = builder.get_active_block()
	var block_bounds:AABB = active_block.control_mesh.calc_bounds_xform(active_block.global_transform)
	var plane:Plane = Plane(drag_floor_normal, block_bounds.get_center())
	var p0_over:bool = plane.is_point_over(plane_origin)

	var height:float = abs(block_bounds.size.dot(drag_floor_normal))
	if p0_over:
		height = -height
		
	return height

func select_block_under_cursor(viewport_camera:Camera3D, mouse_pos:Vector2):
	var origin:Vector3 = viewport_camera.project_ray_origin(mouse_pos)
	var dir:Vector3 = viewport_camera.project_ray_normal(mouse_pos)

	var result:IntersectResults = builder.intersect_ray_closest(origin, dir)
	if result:
		var cmd:CommandSelectBlocks = CommandSelectBlocks.new()
		cmd.builder = builder
		cmd.block_paths.append(result.object.get_path())
		
		if cmd.will_change_anything():
			var undo:EditorUndoRedoManager = builder.get_undo_redo()
			cmd.add_to_undo_manager(undo)
			
			_deactivate()
			_activate(builder)
	

#func select_general_objects_with_ray(viewport_camera:Camera3D, mouse_pos:Vector2):
	#var origin:Vector3 = viewport_camera.project_ray_origin(mouse_pos)
	#var dir:Vector3 = viewport_camera.project_ray_normal(mouse_pos)
#
	#var root:Node = EditorInterface.get_edited_scene_root()
	#select_general_objects_with_ray_recursive(root, origin, dir)
#
	#pass
#
#func select_general_objects_with_ray_recursive(node:Node, origin:Vector3, dir:Vector3):
	#if node is VisualInstance3D:
		#var vi:VisualInstance3D = node
		#var rid:RID = vi.get_instance()
	#
	#pass
	
