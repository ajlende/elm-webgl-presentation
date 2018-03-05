/* eslint-env browser */
/**
* The most basic setup for JavaScript WebGL
*/
window.drawJS = function drawJS() {
    const demoDiv = document.getElementById('js-example')
    if (!demoDiv) return

    /* ============== Get a canvas ==================== */

    const canvas = document.createElement('canvas')
    canvas.width = 400
    canvas.height = 400

    const gl = canvas.getContext('webgl')

    if (!gl) {
        const glMessage = document.createElement('div')
        glMessage.innerHTML = '<a href="http://get.webgl.org/">Enable WebGL</a> to see this content!'
        glMessage.width = 400
        glMessage.height = 400
        demoDiv.appendChild(glMessage)
        return
    }

    demoDiv.appendChild(canvas)

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

    const vertices = new Float32Array([
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
