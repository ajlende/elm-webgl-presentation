## OpenGL Shading Language

[Reference Card (pg. 3-4)](https://www.khronos.org/files/webgl/webgl-reference-card-1_0.pdf)

Notes:

C-like language for programming the programmable parts of the graphics pipeline

Nice operations for matrices and vectors (dot product, cross product, )

WebGL -> OpenGL ES (embedded-systems) 2.0 API (roughly) -> OpenGL 2.0 (subset)

Note: This is NOT covering WebGL2 cause it is not yet supported in Elm.

---


### Vertex Shader

<figure>
![](images/glpipelinetriangles.png)
</figure>

```glsl
attribute vec4 position;
uniform mat4 mvp;

void main() {
    // Transformed position of the vertex in screen space
    gl_Position = mvp * position;
}
```

Notes:

Purpose is to calculate where vertices are in screen space as seen earlier.

Usually just a matrix multiplication of the `gl_Vertex` position by the `gl_ModelViewProjectionMatrix`.

`out vec4 gl_Position`: 4D vector representing the final processed vertex position.

---


### Fragment Shader

<figure>
![](images/glpipelinerasterization.png)
</figure>

```glsl
void main() {
    // Setting Each Pixel To Red
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
```

Notes:

Purpose is to calculate color of each fragment.

Fragments can be thought of as pixels which is why this is sometimes called the pixel shader.

I will use pixel/fragment interchangeably from time to time, but I usually mean fragment.

`out vec4 gl_FragColor`: 4D vector representing the final color which is written in the frame buffer.

---


### Types[\*](https://github.com/elm-community/webgl/issues/36)

<table>
    <tr>
        <td>Scalar types:</td>
        <td>float, int</td>
        <td>32-bits, signed</td>
    </tr>
    <tr>
        <td>Vector types:</td>
        <td>vec2, vec3, vec4</td>
        <td>2D, 3D and 4D floating point vector</td>
    </tr>
    <tr>
        <td>Matrix types:</td>
        <td>mat4</td>
        <td>4x4 floating point matrix</td>
    </tr>
    <tr>
        <td>Sampler types:</td>
        <td>sampler2D</td>
        <td>2D texture</td>
    </tr>
</table>

Notes:

If you have the reference sheet out, you'll see some things missing from this slide.

Elm only type checks the ones here. Sorry, no `bool`.

---


### Attributes

- Input values which change every vertex
- Read-only in vertex shader
- Ex. Vertex position or normals

Notes:


---

### Uniforms

- Do not change during a rendering (per frame)
- Read-only in vertex and fragment shaders
- Ex. Model-view-projection matrix, light positions

Notes:


---


### Varyings

- Pass data from vertex shader to fragment shader
- Interpolated across the primitive (usually float)
- Read-only in fragment shader and read-write in vertex shader
- Ex. colors for smooth shading

Notes:
