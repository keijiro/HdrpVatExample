This is a URP branch of HdrpVatExample that shows how to use Shader Graphs and
Visual Effect Graphs to render VAT (Vertex Animation Texture) on the Universal
Render Pipeline.

See [the master branch] for further details.

[the master branch]: https://github.com/keijiro/HdrpVatExample/

Frequently asked questions
--------------------------

### It works on Desktop but is broken after switching to a mobile platform.

You have to tweak the texture format/compression options. It's recommended to
try RGBA32 first, which should work on every platform. Also note that you
have to use a float or half-float format for normal maps. For this reason,
alpha-packed normals are generally recommended on mobile platforms.
