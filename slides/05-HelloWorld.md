## WebGL Hello World

[View on Ellie](https://ellie-app.com/7Y9SF6KN6a1/0)

Notes:


---


### Imports & Main

```elm
module Main exposing (main)

import Html.Attributes exposing (width, height)
import Math.Vector3 as Vec3 exposing (vec3)
import WebGL exposing (entity, triangles, toHtml)

main =
    toHtml
        [ width 400, height 400 ]
        [ entity vertexShader fragmentShader mesh {} ]
```

Notes:


---


<figure class="stretch">
![](images/elmpipeline.png)
</figure>

Notes:

Refresher of the important bits.

Talk about varyings and attributes in more depth.

---


### Vertex Shader

```elm
vertexShader =
    [glsl|

        attribute vec3 position;
        attribute vec3 color;
        varying vec3 vcolor;

        void main () {
            gl_Position = vec4(position, 1.0);
            vcolor = color;
        }

    |]
```

Notes:


---


### Fragment Shader

```elm
fragmentShader =
    [glsl|

        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }

    |]
```

Notes:


---


### Mesh

```elm
mesh =
    triangles
        [ ( { position = vec3 0 1 0, color = vec3 1 0 0 }
          , { position = vec3 -1 0 0, color = vec3 0 1 0 }
          , { position = vec3 1 0 0, color = vec3 0 0 1 }
          )
        ]
```

Notes:


---

<div class="demo elm-triangle"></div>
