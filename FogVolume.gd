@tool
extends FogVolume

func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("inv_model_mat", global_transform.affine_inverse())
