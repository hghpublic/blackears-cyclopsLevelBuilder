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
extends DataPlane
class_name DataPlaneFloat

@export var data:PackedFloat32Array


func resize(size:int):
	data.resize(size * tuple_size)
	
func get_value(index:int, tuple_index:int = 0)->float:
	return data[index * tuple_size + tuple_index]

func get_value_vec2(index:int)->Vector2:
	return Vector2(data[index * tuple_size], data[index * tuple_size + 1])
	
func get_value_vec3(index:int)->Vector3:
	return Vector3(data[index * tuple_size], data[index * tuple_size + 1], data[index * tuple_size + 2])
	
func get_value_vec4(index:int)->Vector4:
	return Vector4(data[index * tuple_size], data[index * tuple_size + 1], data[index * tuple_size + 2], data[index * tuple_size + 3])
	

func set_value(value:int, index:int, tuple_index:int = 0):
	data[index * tuple_size + tuple_index] = value
	
func set_value_vec2(value:Vector2, index:int):
	data[index * tuple_size] = value.x
	data[index * tuple_size + 1] = value.y

func set_value_vec3(value:Vector3, index:int):
	data[index * tuple_size] = value.x
	data[index * tuple_size + 1] = value.y
	data[index * tuple_size + 2] = value.z

func set_value_vec4(value:Vector4, index:int):
	data[index * tuple_size] = value.x
	data[index * tuple_size + 1] = value.y
	data[index * tuple_size + 2] = value.z
	data[index * tuple_size + 3] = value.w