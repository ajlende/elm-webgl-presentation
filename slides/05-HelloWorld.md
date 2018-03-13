## WebGL Hello World

[View on Ellie](https://ellie-app.com/4Jv7RHmrta1/5)

Notes:

Continuing from the previous example.

---


<figure class="stretch">
![](images/elmpipeline.png)
</figure>

Notes:

Refresher of the important bits of the pipeline.

Focus on 3 qualifiers for getting values into the shaders and `const`:
- `attribute`: Per-vertex variables (mesh data)
- `varying`: Pass value from vertex shader to fragment shader
- `uniform`: Per-frame constant (camera info, textures, etc.)
- `const`: Unchanging constant across the life of the shader program

---


### Imports & Main

```elm
module Main exposing (main)

import Html.Attributes exposing (width, height)
import Math.Vector2 as Vec2 exposing (vec2)
import Math.Vector3 as Vec3 exposing (vec3) -- colors (r, g, b)
import WebGL exposing (entity, triangles, toHtml)

main =
    toHtml
        [ width 400, height 400 ]
        [ entity vertexShader fragmentShader mesh { brightness = 0.5 } ]
```

Notes:

Adding `vec3` to the imports.

Adding a uniform value that we'll keep constant for now.

---


### Mesh

```elm
mesh =
    triangles
        [ ( { position = vec2 -1 1, color = vec3 1 0 0 }
          , { position = vec2 -1 -1, color = vec3 0 1 0 }
          , { position = vec2 1 -1, color = vec3 0 0 1 }
          )
        ]
```

Notes:

Adding a color to each corner of the triangle and changing the size of the triangle to show that the screen space goes from (-1, 1) in horizontal and vertical directions.

---


### Vertex Shader

```glsl
attribute vec2 position;
attribute vec3 color;

varying vec3 vcolor;

void main () {
    vcolor = color * color;
    gl_Position = vec4(position.xy, 0.0, 1.0);
    //                          ^ swizzle
}
```

Notes:

Attributes are the "per-vertex" inputs and are part of Elm's `Mesh`. Each field in the record corresponds to an attribute in the shader.

Varyings are for passing values to the fragment shader. They will get linearly interpolated between.

Color is stored as the square root of the actual value, so if you want correct color interpolation, you need to square the color in the veretx shader to convert the color values to their real values and then square root in the fragment shader. [Minute Physics made a video explaining this.](https://www.youtube.com/watch?v=LKnqECcg6Gw)

Elm will type-check I/O to shaders and let you know if you get it wrong.

You'll also notice that we've combined `position.x` and `position.y` into `position.xy`. This is called a "swizzle" or "swizzling" and saves writing out a lot. If you're accessing all of the values, the `.xy` can be omitted, and it just fills in the values of `x` and `y`.

Think of swizzling like an automatic `...` spread operator in JavaScript.

---


### Fragment Shader

```glsl
precision mediump float;

uniform float brightness;

varying vec3 vcolor;

void main () {
    vec3 color = brightness * sqrt(vcolor);
    gl_FragColor = vec4(color, 1.0);
}
```

Notes:

The `varying` gets written here too.

Uniform for brightness we're going to use here to change the brightness of the rgb value acts like a constant here.

Scalar multiplication of a vector multiplies every value of the vector by that scalar.

Notice the automatic spread of the `vec3 color` without the `.xyz`.

---

<div class="demo elm-hello"></div>
