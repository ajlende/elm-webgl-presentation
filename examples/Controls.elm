module Controls exposing (main)

{-
   Try adding the ability to crouch or to land on top of the crate.
-}

import AnimationFrame
import Html exposing (Html, text, div)
import Html.Attributes exposing (width, height, style)
import Keyboard
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Task exposing (Task)
import Time exposing (Time)
import WebGL exposing (Mesh, Shader, Entity)
import WebGL.Texture as Texture exposing (Texture, Error)
import Window


type alias Model =
    { texture : Maybe Texture
    , keys : Keys
    , size : Window.Size
    , person : Person
    }


type alias Person =
    { position : Vec3
    , velocity : Vec3
    }


type Msg
    = TextureLoaded (Result Error Texture)
    | KeyChange Bool Keyboard.KeyCode
    | Animate Time
    | Resize Window.Size


type alias Keys =
    { left : Bool
    , right : Bool
    , up : Bool
    , down : Bool
    , space : Bool
    }


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


eyeLevel : Float
eyeLevel =
    2


init : ( Model, Cmd Msg )
init =
    ( { texture = Nothing
      , person = Person (vec3 0 eyeLevel -10) (vec3 0 0 0)
      , keys = Keys False False False False False
      , size = Window.Size 0 0
      }
    , Cmd.batch
        [ Task.attempt TextureLoaded (Texture.load "examples/texture/box-side.jpg")
        , Task.perform Resize Window.size
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ AnimationFrame.diffs Animate
        , Keyboard.downs (KeyChange True)
        , Keyboard.ups (KeyChange False)
        , Window.resizes Resize
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        TextureLoaded textureResult ->
            ( { model | texture = Result.toMaybe textureResult }, Cmd.none )

        KeyChange on code ->
            ( { model | keys = keyFunc on code model.keys }, Cmd.none )

        Resize size ->
            ( { model | size = size }, Cmd.none )

        Animate dt ->
            ( { model
                | person =
                    model.person
                        |> move model.keys
                        |> gravity (dt / 500)
                        |> physics (dt / 500)
              }
            , Cmd.none
            )


keyFunc : Bool -> Keyboard.KeyCode -> Keys -> Keys
keyFunc on keyCode keys =
    case keyCode of
        32 ->
            { keys | space = on }

        37 ->
            { keys | left = on }

        39 ->
            { keys | right = on }

        38 ->
            { keys | up = on }

        40 ->
            { keys | down = on }

        _ ->
            keys


move : Keys -> Person -> Person
move { left, right, up, down, space } person =
    let
        direction a b =
            if a == b then
                0
            else if a then
                1
            else
                -1

        vy =
            if space then
                2
            else
                Vec3.getY person.velocity
    in
        if Vec3.getY person.position <= eyeLevel then
            { person
                | velocity =
                    vec3 (direction left right) vy (direction up down)
            }
        else
            person


physics : Float -> Person -> Person
physics dt person =
    let
        position =
            Vec3.add person.position (Vec3.scale dt person.velocity)
    in
        { person
            | position =
                if Vec3.getY position < eyeLevel then
                    Vec3.setY eyeLevel position
                else
                    position
        }


gravity : Float -> Person -> Person
gravity dt person =
    if Vec3.getY person.position > eyeLevel then
        { person
            | velocity =
                Vec3.setY
                    (Vec3.getY person.velocity - 2 * dt)
                    person.velocity
        }
    else
        person



-- View


view : Model -> Html Msg
view { size, person, texture } =
    div []
        [ WebGL.toHtmlWith
            [ WebGL.depth 1
            ]
            [ width size.width, height size.height ]
            (texture
                |> Maybe.map (scene size person)
                |> Maybe.withDefault []
            )
        , div
            [ style
                [ ( "position", "absolute" )
                , ( "font-family", "monospace" )
                , ( "color", "white" )
                , ( "text-align", "center" )
                , ( "left", "20px" )
                , ( "right", "20px" )
                , ( "top", "20px" )
                ]
            ]
            [ text message ]
        ]


message : String
message =
    "Walk around with a first person perspective.\n"
        ++ "Arrows keys to move, space bar to jump."


scene : Window.Size -> Person -> Texture -> List Entity
scene { width, height } person texture =
    let
        perspective =
            Mat4.mul
                (Mat4.makePerspective 45 (toFloat width / toFloat height) 0.01 100)
                (Mat4.makeLookAt person.position (Vec3.add person.position Vec3.k) Vec3.j)
    in
        [ WebGL.entity
            vertexShader
            fragmentShader
            crate
            { texture = texture
            , perspective = perspective
            }
        ]



-- Mesh


type alias Vertex =
    { position : Vec3
    , coord : Vec2
    }


crate : Mesh Vertex
crate =
    [ ( 0, 0 ), ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, -90 ) ]
        |> List.concatMap rotatedSquare
        |> WebGL.triangles


rotatedSquare : ( Float, Float ) -> List ( Vertex, Vertex, Vertex )
rotatedSquare ( angleXZ, angleYZ ) =
    let
        transformMat =
            Mat4.mul
                (Mat4.makeRotate (degrees angleXZ) Vec3.j)
                (Mat4.makeRotate (degrees angleYZ) Vec3.i)

        transform vertex =
            { vertex
                | position =
                    Mat4.transform transformMat vertex.position
            }

        transformTriangle ( a, b, c ) =
            ( transform a, transform b, transform c )
    in
        List.map transformTriangle square


square : List ( Vertex, Vertex, Vertex )
square =
    let
        topLeft =
            Vertex (vec3 -1 1 1) (vec2 0 1)

        topRight =
            Vertex (vec3 1 1 1) (vec2 1 1)

        bottomLeft =
            Vertex (vec3 -1 -1 1) (vec2 0 0)

        bottomRight =
            Vertex (vec3 1 -1 1) (vec2 1 0)
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]



-- Shaders


type alias Uniforms =
    { texture : Texture
    , perspective : Mat4
    }


vertexShader : Shader Vertex Uniforms { vcoord : Vec2 }
vertexShader =
    [glsl|

        attribute vec3 position;
        attribute vec2 coord;
        uniform mat4 perspective;
        varying vec2 vcoord;

        void main () {
          gl_Position = perspective * vec4(position, 1.0);
          vcoord = coord;
        }

    |]


fragmentShader : Shader {} Uniforms { vcoord : Vec2 }
fragmentShader =
    [glsl|

        precision mediump float;
        uniform sampler2D texture;
        varying vec2 vcoord;

        void main () {
          gl_FragColor = texture2D(texture, vcoord);
        }

    |]
