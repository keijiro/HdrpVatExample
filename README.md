VAT (Vertex Animation Texture) on HDRP examples
===============================================

![gif](https://i.imgur.com/WyMafY5.gif)

![gif](https://i.imgur.com/9FNn6sv.gif)

This is a repository that contains examples of the use of VAT (Vertex Animation
Texture) on Unity High Definition Render Pipeline (HDRP).

In this document, "VAT" refers explicitly to the texture encoding method used
in Houdini's [Game Development Toolset].

[Game Development Toolset]:
  https://github.com/sideeffects/GameDevelopmentToolset

System requirements
-------------------

- Unity 2019.3
- HDRP 7.1

Supported VAT methods
---------------------

- The Shader Graph example only supports the "Soft (Consistent Topology)"
  method.
- The Visual Effect Graph example only supports the "Sprite (Camera Facing
  Cards)" method.

How to use VAT with Shader Graph
--------------------------------

At first, export a geometry (`.fbx`), textures (`.exr`) and realtime data
(`.json`) from Houdini using the VAT exporter and import `.fbx` and `.exr`
files into Unity. Note that the texture files should be imported with the
following settings:

- sRGB (Color Texture): Off
- Non-Power of 2: None
- Generate Mip Maps: Off
- Format: For position maps, "Automatic" is recommended. You can select a lower
  BPP format with sacrificing quality. For normal maps, "RGB 16 bit" is
  recommended.
- Compression: "None" is recommended. You can try other options, but usually
  they don't work under a non-power of two resolution.

![importer](https://i.imgur.com/01SK60b.png)

You can use a shader graph named "Shader Graph/Cloth" to animate the mesh.

![material](https://i.imgur.com/tyLWdYQ.png)

The "\_numOfFrames", "\_posMax" and "\_posMin" properties must be set based on
the realtime data. Open the exported `.json` file with a text editor and
copy-paste these values to the material properties.

You can use the packed-normal encoding (the "Pack normals into Position Alpha"
option in the VAT exporter) with enabling the "Use Packed Normals" option in
the material. Note that it significantly increases the quantization error in
normal vectors.

To animate the mesh, you have to control the "Current Frame" property manually.
In the "Cloth" example, this property is controlled by a timeline.

The structure of the shader graph is quite simple. You can easily extend it to
add features, like adding a color map or support of different surface types.
For example, in the "Cloth" example, it uses an extended shader graph named
"Cloth Lerp" that interpolates positions/normals between consecutive frames to
achieve smooth animation.

How to use VAT with Visual Effect Graph
---------------------------------------

You can use a custom subgraph block named "Set VAT Attributes" that updates the
position and color attributes based on the given VATs.

![block](https://i.imgur.com/sCVyPtP.png)

Note that a sprite VAT can contain "texture size * 3" particles. It should
initially emit "texture size * 3" particles using the Single Burst block.

Frequently Asked Questions
--------------------------

#### Is it possible to support Universal RP?

Yes. Although these examples are created with HDRP, you can use the same
approach on Universal RP. These shader graphs and VFX graphs can be converted
by changing a few options.
