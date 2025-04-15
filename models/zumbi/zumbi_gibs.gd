extends Node3D

var forca = 400

func explodir(fonte):
	var pedacos = get_children()
	for pedaco in pedacos:
		pedaco.apply_central_force((global_transform.origin - fonte).normalized() * forca)
