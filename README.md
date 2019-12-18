VAT VFX Example
===============

![gif](https://i.imgur.com/9FNn6sv.gif)

This is a repository that contains an example of the use of VAT (Vertex
Animation Texture) with Unity Visual Effect Graph.

In this example, "VAT" specifically refers to a texture encoding method used in
Houdini's [Game Development Toolset].

[Game Development Toolset]:
  https://github.com/sideeffects/GameDevelopmentToolset

System Requirements
-------------------

- Unity 2019.3
- Visual Effect Graph 7.1

What type of VAT does it support?
---------------------------------

At the moment, it only supports VAT generated with the "Sprite (Camera Facing
Cards)" method.

How to use VAT with VFX Graph
-----------------------------

At first, import VATs as raw SFloat textures.

![inspector](https://i.imgur.com/8Po44HC.png)

This example contains a custom subgraph block named "Set VAT Attributes" that
updates the position and color attributes based on the given VATs.

![block](https://i.imgur.com/sCVyPtP.png)

The "BBox Min" and "BBox Max" values are shown in the VAT exporter. You have to
copy-paste these values from Houdini.

Note that a sprite VAT can contain "texture size * 3" particles. It should
initially emit "texture size * 3" particles using the Single Burst block.

Frequently Asked Questions
--------------------------

#### Does it support (Soft | Rigid | Fluid) type VATs?

No, it doesn't. The VFX Graph doesn't support mesh deformation at the moment.
You can only use a VAT point cloud as a particle animation source.

#### Can I use the "Export for Mobile" option or a texture compression method?

It depends on the case -- It may work with an acceptable amount of errors in
some cases, but it may glitch in some other cases. A trial-and-error approach
would be required.
