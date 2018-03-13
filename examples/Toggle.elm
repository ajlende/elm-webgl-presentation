module Toggle exposing (main)

{-
   The triangle that is the "hello world" of WebGL
-}

import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (width, height, type_)
import Html.Events exposing (onClick)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)


-- Program


type alias Model =
    Bool


type Msg
    = Toggle


model : Model
model =
    False


view : Model -> Html Msg
view model =
    div []
        [ WebGL.toHtml [ width 400, height 400 ]
            [ WebGL.entity vertexShader fragmentShader mesh (uniforms model) ]
        , label []
            [ input [ type_ "checkbox", onClick Toggle ] []
            , text "Toggle"
            ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle ->
            not model


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


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


uniforms : Model -> Uniforms
uniforms model =
    { brightness = if model then 1 else 0 }


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
