module Hello exposing (main)

{-
   The triangle that is the "hello world" of WebGL
-}

import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)


main : Html msg
main =
    WebGL.toHtml
        [ width 400, height 400 ]
        [ WebGL.entity vertexShader fragmentShader mesh uniforms ]



-- Mesh


type alias Attributes =
    { position : Vec2
    , color : Vec3
    }


mesh : Mesh Attributes
mesh =
    WebGL.triangles
        [ ( Attributes (vec2 -1 1) (vec3 1 0 0)
          , Attributes (vec2 -1 -1) (vec3 0 1 0)
          , Attributes (vec2 1 -1) (vec3 0 0 1)
          )
        ]


-- Uniforms

type alias Uniforms =
    { brightness : Float }


uniforms : Uniforms
uniforms =
    { brightness = 0.5 }

-- Shaders

type alias Varyings =
    { vcolor : Vec3 }

vertexShader : Shader Attributes Uniforms Varyings
vertexShader =
    [glsl|

        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vcolor;

        void main () {
            vcolor = color * color;
            gl_Position = vec4(position, 0.0, 1.0);
        }

    |]


fragmentShader : Shader {} Uniforms Varyings
fragmentShader =
    [glsl|

        precision mediump float;

        uniform float brightness;

        varying vec3 vcolor;

        void main () {
            vec3 color = brightness * sqrt(vcolor);
            gl_FragColor = vec4(color, 1.0);
        }

    |]
