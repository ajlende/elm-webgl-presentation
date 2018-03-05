## What's Elm?

[elm-lang.org](http://elm-lang.org/)

Notes:

- Programming language for building webapps
- Delightful experience
- No runtime exceptions

---


### A Delightful Language for Reliable Webapps

[Let's be Mainstream!](http://www.elmbark.com/2016/03/16/mainstream-elm-user-focused-design)

Notes:

Emphasis on simplicity, ease of use, and quality tooling

Next version focusing more on shipping production web webapps

Comparable to React in terms of bundle size and performance

---


### No Runtime Exceptions

[Compilers as Assistants](http://elm-lang.org/blog/compilers-as-assistants)

Notes:

Statically typed language that catches errors during compilation

No `null` or `undefined is not a function`

Incredibly easy to refactor because the compiler tells you where you need to fix things

Enforced semantic versioning removes surprises in minor and patch releases

---


## Why Elm?

Notes:

Now it's time to mention that it's a functional programming language

Specifically, why Elm for WebGL

- Easy to lean
- Less boilerplate
- Integrated into lang
- Type checking
- Functional ;)

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

<div class="demo" id="js-example"></div>

---

### Helpful Error Messages

<figure class="stretch">
![](images/mismatch.png)
</figure>
