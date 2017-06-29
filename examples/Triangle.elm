module Triangle exposing (main)

{-
   The triangle that is the "hello world" of WebGL
-}

import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)


main : Program Never {} {}
main =
    Html.beginnerProgram
        { model = {}
        , view = view
        , update = (\_ _ -> {})
        }


view : {} -> Html msg
view _ =
    WebGL.toHtml
        [ width 400, height 400 ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            {}
        ]



-- Mesh


type alias Vertex =
    { position : Vec3
    , color : Vec3
    }


mesh : Mesh Vertex
mesh =
    WebGL.triangles
        [ ( Vertex (vec3 0 1 0) (vec3 1 0 0)
          , Vertex (vec3 -1 0 0) (vec3 0 1 0)
          , Vertex (vec3 1 0 0) (vec3 0 0 1)
          )
        ]



-- Shaders


vertexShader : Shader Vertex {} { vcolor : Vec3 }
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


fragmentShader : Shader {} {} { vcolor : Vec3 }
fragmentShader =
    [glsl|

        precision mediump float;
        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }

    |]
