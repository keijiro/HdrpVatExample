VAT (Vertex Animation Texture) on Unity HDRP examples
=====================================================

This is a repository that contains examples of the use of VAT (Vertex Animation
Texture) on Unity High Definition Render Pipeline (HDRP).

In this document, "VAT" refers explicitly to the texture encoding method used
in Houdini and [SideFX Labs].

[SideFX Labs]: https://github.com/sideeffects/SideFXLabs

![gif](https://i.imgur.com/Ctsa3av.gif)
![gif](https://i.imgur.com/rYmtjLZ.gif)
![gif](https://i.imgur.com/n4WL4Qy.gif)
![gif](https://i.imgur.com/idCLijy.gif)

*Several types of VAT: Soft, Rigid, Fluid and Sprite*

System requirements
-------------------

- Unity 2019.3
- HDRP 7.1

How to use VAT with Shader Graph
--------------------------------

At first, export VAT files from Houdini. It consists of a geometry file
(`.fbx`), texture files (`.exr`) and a realtime data file (`.json`). Then
import `.fbx` and `.exr` files into Unity. The texture files must be imported
with the following settings:

- sRGB (Color Texture): Off
- Non-Power of 2: None
- Generate Mip Maps: Off
- Format: "Automatic" is recommended. You can select a lower BPP format with
  sacrificing quality.
- Compression: "None" is recommended. You can try other options, but usually,
  they don't work with non-power of two textures.

![importer](https://i.imgur.com/01SK60b.png)

There are three types of shader graphs under the "Shader Graph" group: Soft,
Rigid, and Fluid. You can use corresponding VAT methods with these shader
graphs.

These shader graphs have some VAT dependent properties.

![material](https://i.imgur.com/tyLWdYQ.png)

The "\_numOfFrames", "\_posMax" and "\_posMin" properties must be set based on
the realtime data. Open the exported `.json` file with a text editor and
copy-paste these values to the corresponding properties.

You can use the packed-normal encoding (the "Pack normals into Position Alpha"
option in the VAT exporter) with enabling the "Use Packed Normals" option in
the material settings. Note that this may significantly increase the
quantization errors in normal vectors.

To animate the mesh, you have to control the "Current Frame" property manually.
Using a timeline would be the handiest way to do it.

The structure of the shader graph is quite simple. You can easily extend it to
add features, like adding a albedo map or support of different surface types.

For example, an extended shader graph named "Soft Lerp" is used in the Soft
example, that interpolates positions/normals between consecutive frames to
achieve smooth animation.

How to use VAT with Visual Effect Graph
---------------------------------------

You can use a Sprite VAT to move particles in a Visual Effect graph; Other
methods are not supported at the moment.

This project contains the following three subgraph operators that are designed
to be used with VAT.

**VAT Particle Count** -- Calculates the number of particles contained in VAT.
This is convenient to determine the number of particles to emit in the Spawn
context.

**VAT Particle UV** -- Calculates the texture coordinates for each particle.
This can be used to retrieve data from a position map.

**VAT Convert Position** -- Converts position data into a object space position
vector.

For detailed usage of these operators, see Sprite example in this project.

Frequently Asked Questions
--------------------------

#### Is it possible to support Universal RP?

Yes. Although these examples are created with HDRP, you can use the same
approach on Universal RP. These shader graphs and VFX graphs can be converted
by changing a few options. Check [the URP branch] for details.

[the URP branch]: https://github.com/keijiro/HdrpVatExample/tree/urp
