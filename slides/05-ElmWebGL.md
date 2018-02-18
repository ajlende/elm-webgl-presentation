## Elm WebGL

[elm-community/webgl](http://package.elm-lang.org/packages/elm-community/webgl/latest)

Note:


---

### Compiler

Uses Haskell's `Language.GLSL.Parser` to parse and compile glsl shaders from Elm source code for type checking

```elm
fragmentShader : Shader Attributes Uniforms Varyings
fragmentShader =
    [glsl|

        void main () {
            gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
        }

    |]
```

Note:

Within the <code>[glsl| ... |]</code> block, you just write plain GLSL. Elm is actually aware of the types of the attributes, uniforms, and varyings coming in and out of the shader, so the shader block is given a type that enforces this API. The type of vertexShader says that we have two attributes named position and coord, one uniform named view, and one varying called vcoord. This means Elm's type checker can make sure you are using the shader in a meaningful way, avoiding a totally blank screen that can happen if your shader has an error in it.
