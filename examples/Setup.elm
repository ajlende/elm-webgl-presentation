module Setup exposing (main)

{-
   The most basic setup for Elm WebGL
-}

import Html exposing (Html)
import Html.Attributes exposing (height, width)
import Math.Vector2 exposing (Vec2, vec2)
import WebGL exposing (Shader, Mesh, entity, triangles, toHtml)


vertexShader : Shader { position : Vec2 } {} {}
vertexShader =
    [glsl|

        attribute vec2 position;

        void main () {
            gl_Position = vec4(position, 0.0, 1.0);
        }

    |]


fragmentShader : Shader {} {} {}
fragmentShader =
    [glsl|

        void main () {
            gl_FragColor = vec4(0.027, 0.216, 0.275, 1.0);
        }

    |]


mesh : Mesh { position : Vec2 }
mesh =
    triangles
        [ ( { position = vec2 0 0 }
          , { position = vec2 0 1 }
          , { position = vec2 1 0 }
          )
        ]


main : Html msg
main =
    toHtml
        [ width 400, height 400 ]
        [ entity vertexShader fragmentShader mesh {} ]
