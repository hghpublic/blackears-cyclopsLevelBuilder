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
class_name CyclopsAction

@export_multiline var tooltip:String

#var plugin:CyclopsLevelBuilder

#var name:String = ""
#var accellerator:Key = KEY_NONE

func _get_action_id():
	return ""

func _ready():
	pass

#func _init(plugin:CyclopsLevelBuilder, name:String = "", accellerator:Key = KEY_NONE):
	#self.plugin = plugin
	#self.name= name
	#self.accellerator = accellerator

#func _run(event:CyclopsActionEvent):
	#pass

func invoke(context:CyclopsOperatorContext, event:InputEvent):
	#_execute()
	pass
	
func _execute(event:CyclopsActionEvent):
	pass

	
func calc_pivot_of_blocks(blocks:Array[CyclopsBlock])->Vector3:
	var snap_to_grid_util:SnapToGridUtil = CyclopsAutoload.calc_snap_to_grid_util()
	
	var bounds:AABB = blocks[0].control_mesh.bounds
	for idx in range(1, blocks.size()):
		var block:CyclopsBlock = blocks[idx]
		bounds = bounds.merge(block.control_mesh.bounds)
	
	var center:Vector3 = bounds.get_center()
	center = snap_to_grid_util.snap_point(center)
	
	return center
	
