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
extends Resource
class_name ConvexBlockData

#@export var face_planes:Array[Plane]
#@export var face_uv_transform:Array[Transform2D]
#@export var face_material_indices:PackedInt32Array
#@export var face_ids:PackedInt32Array

@export var vertex_points:PackedVector3Array  #Per vertex
@export var vertex_selected:PackedByteArray  #Per vertex

@export var edge_vertex_indices:PackedInt32Array
@export var edge_selected:PackedByteArray

@export var face_vertex_count:PackedInt32Array #Number of verts in each face
@export var face_vertex_indices:PackedInt32Array  #Vertex index per face
@export var face_material_indices:PackedInt32Array #Material index for each face
@export var face_uv_transform:Array[Transform2D]
@export var face_selected:PackedByteArray  #Per face
@export var face_ids:PackedInt32Array  #Per face

