module Cube exposing (main)

{-
   The triangle that is the "hello world" of WebGL
-}

import AnimationFrame
import Color exposing (Color, toRgb)
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (width, height, type_)
import Html.Events exposing (onClick)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Time exposing (Time)
import WebGL exposing (Mesh, Shader, triangles, entity, toHtml)


-- Program


type alias Model =
    { toggle : Bool
    , theta : Float
    }


type Msg
    = Toggle
    | Animate Time


init : (Model, Cmd msg)
init =
    ( { toggle = False
      , theta = 0
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    AnimationFrame.diffs Animate


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


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
        Toggle ->
            ( { model | toggle = not model.toggle }, Cmd.none )
        Animate dt ->
            ( { model | theta = model.theta + dt / 5000 }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


-- Mesh


type alias Attributes =
    { position : Vec3
    , color : Vec3
    }


colorToVec3 : Color -> Vec3
colorToVec3 rawColor =
    let
        c = toRgb rawColor
    in
        vec3
            (toFloat c.red / 255)
            (toFloat c.green / 255)
            (toFloat c.blue / 255)


face : Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Attributes, Attributes, Attributes )
face rawColor a b c d =
    let
        vertex position =
            Attributes position (colorToVec3 rawColor) 
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]


mesh : Mesh Attributes
mesh =
    let
        rft =
            vec3 1 1 1

        lft =
            vec3 -1 1 1

        lbt =
            vec3 -1 -1 1

        rbt =
            vec3 1 -1 1

        rbb =
            vec3 1 -1 -1

        rfb =
            vec3 1 1 -1

        lfb =
            vec3 -1 1 -1

        lbb =
            vec3 -1 -1 -1
    in
        [ face Color.green rft rfb rbb rbt
        , face Color.blue rft rfb lfb lft
        , face Color.yellow rft lft lbt rbt
        , face Color.red rfb lfb lbb rbb
        , face Color.purple lft lfb lbb lbt
        , face Color.orange rbt rbb lbb lbt
        ]
            |> List.concat
            |> triangles


-- Uniforms


type alias Uniforms =
    { brightness : Float 
    , perspective : Mat4
    , camera : Mat4
    , rotation : Mat4
    }


uniforms : Model -> Uniforms
uniforms model =
    { brightness = if model.toggle then 0.8 else 0.2
    , rotation =
        Mat4.mul
            (Mat4.makeRotate (3 * model.theta) (vec3 0 1 0))
            (Mat4.makeRotate (2 * model.theta) (vec3 1 0 0))
    , perspective = Mat4.makePerspective 45 1 0.01 100
    , camera = Mat4.makeLookAt (vec3 0 0 5) (vec3 0 0 0) (vec3 0 1 0)
    }


-- Shaders


type alias Varyings =
    { vcolor : Vec3 }


vertexShader : Shader Attributes Uniforms Varyings
vertexShader =
    [glsl|

        attribute vec3 position;
        attribute vec3 color;

        uniform mat4 perspective;
        uniform mat4 camera;
        uniform mat4 rotation;

        varying vec3 vcolor;

        void main () {
            vcolor = color;
            gl_Position = perspective * camera * rotation * vec4(position, 1.0);
        }

    |]


fragmentShader : Shader {} Uniforms Varyings
fragmentShader =
    [glsl|

        precision mediump float;

        uniform float brightness;

        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(brightness * vcolor, 1.0);
        }

    |]