## First Drawing

[View on Ellie](https://ellie-app.com/5YkQwmqbRa1/3)

---


### Overview

<figure class="stretch">
![](images/elmpipeline.png)
</figure>

---


### Setup

#### Main.elm

```elm
module Main exposing (main)
```

#### index.html

```html
<html>
<head></head>
<body>
  <script>
    var app = Elm.Main.fullscreen()
  </script>
</body>
</html>
```

---


### Mesh

```elm
import WebGL exposing (triangles)
import Math.Vector2 exposing (vec2)

mesh =
    triangles
        [ ( { position = vec2 0 1 }
          , { position = vec2 0 0 }
          , { position = vec2 1 0 }
          )
        ]
```

---


### Vertex Shader

```elm
vertexShader =
    [glsl|

        attribute vec2 position;

        void main () {
            gl_Position = vec4(position.x, position.y, 0.0, 1.0);
        }

    |]
```

---


### Fragment Shader

```elm
fragmentShader =
    [glsl|

        void main () {
            gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
        }

    |]
```

---


### Main

```elm
import WebGL exposing (entity, triangles, toHtml)
import Html.Attributes exposing (height, width)

main =
    toHtml
        [ width 400, height 400 ]
        [ entity vertexShader fragmentShader mesh {} ]
```

---

<div class="demo" id="elm-setup"></div>
