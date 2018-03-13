## First Drawing

[View on Ellie](https://ellie-app.com/4Jv7RHmrta1/1)

Notes:


---


### Overview

<figure class="stretch">
![](images/elmpipeline.png)
</figure>

Notes:

Overview of the important bits.


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

Notes:

Ellie link shows the completed program for this example. Click `new` on Ellie if you want to follow along.

Basic setup in Ellie shows `Main.elm` at the top and `index.html` at the bottom. We're not going to touch the HTML.

Add dependencies:
- elm-community/webgl
- elm-community/linear-algebra
- elm-lang/animation-frame (won't be used for the first two examples, but we'll use it later)

---


### Main

```elm
import WebGL exposing (entity, toHtml)
import Html.Attributes exposing (height, width)

main =
    toHtml
        [ width 400, height 400 ]
        [ entity vertexShader fragmentShader mesh {} ]
```

Notes:


Functions look weird in elm cause they don't have parenthesis or commas. (Optional parenthesis go around the function name too)

```elm
WebGL.toHtml
    : List (Attribute msg) -- canvas attributes
    -> List Entity         -- scene
    -> Html msg            -- <canvas />
```

```elm
WebGL.entity
    :  Shader attributes uniforms varyings -- Vertex Shader
    -> Shader {  } uniforms varyings       -- Fragment Shader
    -> Mesh attributes                     -- Mesh
    -> uniforms                            -- Uniforms (for now "empty object")
    -> Entity                              -- Entity
```

---


### Mesh

```elm
import WebGL exposing (..., triangles)
import Math.Vector2 exposing (vec2)

mesh =
    triangles
        [ ( { position = vec2 0 1 }
          , { position = vec2 0 0 }
          , { position = vec2 1 0 }
          )
        ]
```

Notes:

Just creating the points of a triangle with corners at (0, 1), (0, 0), and (1, 0)

```elm
triangles
    : List (attributes, attributes, attributes) -- List of triples representing 
    -> Mesh attributes -- Mesh                     the corners of a triangle
```

```elm
vec2 : Float -> Float -> Vec2 -- (x, y) coordinates kinda like a tuple of Floats
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

Notes:

GLSL block of actual GLSL code. Looks a lot like C. This is the code that runs in the GPU.

`position` is from the mesh. Vertex shader runs once for each vertex of the mesh.

`gl_Position` is a built-in `out` vairable if you're familiar with C++. `(x, y, z, w)` (w is used for scaling/perspectives)

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

Notes:

Fragment shader runs once for each "fragment", or pixel of the screen, so you usually want this to be fast.

`gl_FragColor` is a built-in `out` vairable for the color of each pixel to be drawn.

---

<div class="demo elm-setup"></div>

---


### JavaScript Boilerplate

```js
/**
 * The most basic setup for JavaScript WebGL
 */
window.drawJS = () => {
    /* ============== Get a canvas ==================== */

    const canvas = document.createElement('canvas')
    canvas.width = 400
    canvas.height = 400

    const gl = canvas.getContext('webgl')

    if (!gl) {
        const glMessage = document.createElement('div')
        glMessage.innerHTML =
          'Enable WebGL to see this content!'
        document.body.appendChild(glMessage)
        return
    }

    document.body.appendChild(canvas)

    const prog = gl.createProgram()


    /* ================ Shaders ==================== */

    const vertSource = `
attribute vec2 position;

void main () {
    gl_Position = vec4(position, 0.0, 1.0);
}`
    const vertShader = gl.createShader(gl.VERTEX_SHADER)
    gl.shaderSource(vertShader, vertSource)
    gl.compileShader(vertShader)

    const fragSource = `
void main () {
    gl_FragColor = vec4(0.027, 0.216, 0.275, 1.0);
}`
    const fragShader = gl.createShader(gl.FRAGMENT_SHADER)
    gl.shaderSource(fragShader, fragSource)
    gl.compileShader(fragShader)


    /* ======= Associate shaders to buffer objects ======= */

    gl.attachShader(prog, vertShader)
    gl.attachShader(prog, fragShader)
    gl.linkProgram(prog)
    gl.useProgram(prog)


    /* ======== Define and store the geometry =========== */

    const vertices =
        new Float32Array([
            0, 0,
            0, 1,
            1, 0,
        ])

    const vertexBuf = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuf)
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW)

    const position = gl.getAttribLocation(prog, 'position')
    gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(position)


    /* ========= Draw the triangle =========== */

    gl.viewport(0, 0, canvas.width, canvas.height)

    gl.drawArrays(gl.TRIANGLES, 0, 3)
}
```

Notes:

Notice all the buffer binding and direct memory management

Tools like three.js mitigate this, but if you're interested in lower-level graphics I think this is a better place to start

---

<div
    class="group"
    style="display: grid; grid-auto-flow: column; justify-items: center; align-items: start; grid-template-rows: auto auto; grid-auto-columns: 1fr;"
>
    <p class="fragment" data-fragment-index="1">1. Draw a triangle</p>
    <div class="fragment demo" style="margin: 0;" data-fragment-index="1" id="js-example"></div>
    <p class="fragment" data-fragment-index="2">2. Draw the rest of the game</p>
    <div class="fragment" data-fragment-index="2">
        <img
            alt="rest of the f*ing game"
            src="images/restoftheeffinggame.jpg"
            style="width: calc(400px + 2rem); height: calc(400px + 2rem); margin: 0; max-width: 100%; max-height: 100%; object-fit: cover;"
        />
    </div>
</div>

Notes:

Step 1: Draw a triangle
Step 2: Draw the rest of the game

After all, the drawings for almost all games are just a collection of triangles. (Joke)
