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

At first, export textures (`.exr`) and a static mesh (`.fbx`) from Houdini using
the VAT exporter and import those files into Unity. Note that the texture files
should be imported as raw SFloat textures (see the screenshot below for
detailed import settings).

![importer](https://i.imgur.com/8Po44HC.png)

You can use a shader graph named "Shader Graph/Cloth" to animate the mesh.

![material](https://i.imgur.com/rPJYxjW.png)

The "BBOX MIN"/"BBOX MAX" and "Number of Frames" properties must be set based
on the export settings. These BBOX values are shown in Houdini when an exporting
is done. When calculating the number of frames, note that you shouldn't take the
last frame into account. For example, when the start frame is 1, and the end
frame is 100, the "Number of Frames" must be set to 99.

You can also use the packed-normal encoding where the exporter embeds normal
vectors into the alpha channel of the position map. To use this option, enable
"Use Packed Normal" and unset the Normal Map property.

To animate the mesh, you have to control the "Current Frame" property manually.
In the "Cloth" example, this property is controlled by a timeline.

The structure of the shader graph is quite simple. You can easily extend it to
add features, like adding a color map or support of different surface types.

How to use VAT with Visual Effect Graph
---------------------------------------

As same as the Shader Graph example, VAT textures  should be imported as raw
SFloat textures.

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

#### Can I use the "Export for Mobile" option or a texture compression method?

It depends on the case -- It may work with an acceptable amount of errors in
some cases, but it may glitch in some other cases. A trial-and-error approach
would be required.
