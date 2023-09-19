# GodotFogVolumes
Fog volume's fog shaders as a temporary option before FogVolume's are fixed in Godot 4.x

Notes:
1. These shaders have the same shapes as Godot ones and same parameters. This is because I just extracted the necessary code from the engine
itself and then slightly adjusted it to make it work that's all.
2. The FogVolumes like this won't be culled at all since they are set to world space. Best advice I can give you is to either not do anything
   if it's not a problem or just check if they are in the view or not and then show/hide them. For anything more complex it's up to you if
   you really (!) need it.

Instructions:
1. Add FogVolume node to your scene.
2. Set its shape to `World (Global)`
3. As a shader load one of the shaders in this repo (BoxFV, CylinderFV, ...)
4. In the Shader Parameters set Size, Albedo, ... as you want
5. In case you also want to move the fog around and rotate it you need to pass the global_transform to `inv_model_mat` shader parameter,
   for this matter the `FogVolume.gd` script is included, it's a simple `@tool` script to show you how (after you assign the tool script
   it's better to reload the project so it takes effect). It's not recommended to pass the transform every frame unless it's necessary
   for your case - for example static fog which will be set at one place and never moved needs to have the transform passed only once
   after you place it in your game so why waste performance on `_process` if you don't need it, a moving fog (for example a smoke grenade
   going off in flight) will need to have the transform added every frame (although you can set it only at times when it moves to save some
   pico seconds ;D). It's up to you how you handle this, it's simple.
