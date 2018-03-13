## Graphics Pipeline

[Detailed Map](http://www.seas.upenn.edu/~pcozzi/OpenGLInsights/OpenGLES30PipelineMap.pdf)

Notes:

This fantastic flowchart is actually a newer version than we're actually using, but the same main concepts remain.

---


<figure class="stretch">
![](images/glpipeline.png)
</figure>

Notes:

Overview of the programmable graphics pipeline.

Inputs on top, GPU process in the middle

Output on the bottom

---


<figure class="stretch">
![](images/glpipeline1.png)
</figure>

Notes:

Vertex array buffer (aka Vertex Buffer Object or VBO): Every unique vertex. Buffer is just a continuous chunk of memory that gets allocated in javascript and interpreted different ways. Elm abstracts that away into just a List of records.

Element array buffer (aka Element Buffer Object or EBO): Which vertices make up a triangle when there are repeats as a way to compress the data sent to the GPU. Again, Elm abstracts this into a List of triples.

---


<figure class="stretch">
![](images/glpipeline2.png)
</figure>

Notes:

Uniforms are like "constants per frame". That is, they get passed into both the vertex shader and fragment shader.

In the fragment shader uniforms include things like object scaling/transformations or the camera information.

I have textures drawn here, but those are used in the fragment shader and on some hardware and in the supported version of WebGL are not supported either. They just go by the same name.

This is the first programmable bit that turns the input numbers into positioned points with the vertices.

---


<figure class="stretch">
![](images/glpipeline3.png)
</figure>

Notes:

Part of the fixed pipeline. (i.e. not programmable)

Turns points into triangles.

---


<figure class="stretch">
![](images/glpipeline4.png)
</figure>

Notes:

Also part of the fixed pipeline. (i.e. not programmable)

Process called "rasterization" turns the primitive triangles into fragments (pixel coordinates)

Many people will use fragments and pixels interchangebly, and you might hear me use them interchangebly when talking about drawing to the screen. (pixels are a physical thing; fragments are more conceptual. they aren't always 1:1.)

---


<figure class="stretch">
![](images/glpipeline5.png)
</figure>

Notes:

Another programmable part of the pipeline.

Uniforms again. This time the textures are used.

Tells each fragment what color it should be. Colors get linearly interpolated across from the vertices. We'll do an example of this next.

---


<figure class="stretch">
![](images/glpipeline6.png)
</figure>

Notes:

The fragments then get stored in a framebuffer which, in our examples, will get drawn directly to the screen.

(Sometimes people re-use past framebuffers to compute things like motion blur.)

---


<figure class="stretch">
![](images/glpipeline.png)
</figure>

Notes:

Overview again. We'll do another example next, but hopefully this part was interesting and will help put the remainder of the examples in context.