module Mandelbrot exposing (main)

{-| The Mandelbrot Set zooming into a place that I think is interesting.
Colors represent the number of iterations it went through to determine if it was in the set
-}

import AnimationFrame
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (height, type_, width)
import Math.Vector2 exposing (Vec2, vec2)
import Time exposing (Time, inSeconds)
import WebGL exposing (Entity, Mesh, Shader, entity, indexedTriangles, toHtml)


-- Program


type alias Model =
    { time : Time
    , scale : Vec2
    , coord : Vec2
    }


type Msg
    = Animate Time


init : ( Model, Cmd Msg )
init =
    ( { time = 0
      , scale = vec2 0 0
      , coord = vec2 0 0
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    toHtml [ width 400, height 400 ] (scene model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate t ->
            ( { model | time = t }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    AnimationFrame.times Animate


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Scene


scene : Model -> List Entity
scene model =
    [ entity vertexShader fragmentShader mesh (uniforms model) ]



-- Mesh


type alias Attributes =
    { position : Vec2
    , uv : Vec2
    }


mesh : Mesh Attributes
mesh =
    indexedTriangles
        [ Attributes (vec2 -1 1) (vec2 0 0)
        , Attributes (vec2 -1 -1) (vec2 0 1)
        , Attributes (vec2 1 -1) (vec2 1 1)
        , Attributes (vec2 1 1) (vec2 1 0)
        ]
        [ ( 0, 1, 2 )
        , ( 0, 2, 3 )
        ]



-- Uniforms


type alias Uniforms =
    { time : Float
    , scale : Vec2
    , coord : Vec2
    }


uniforms : Model -> Uniforms
uniforms model =
    let
        t =
            model.time |> inSeconds
    in
    let
        s =
            1 / ((1000 * (cos ((0.1 * t) + pi) + 1) ^ 8) + 0.25)
    in
    { time = t
    , scale = vec2 s s
    , coord = vec2 -0.761579 -0.0847595
    -- , coord = vec2 0.251 -0.00005
    }



-- Shaders


type alias Varyings =
    { vuv : Vec2 }


vertexShader : Shader Attributes Uniforms Varyings
vertexShader =
    [glsl|
        attribute vec2 position;
        attribute vec2 uv;

        varying vec2 vuv;

        void main () {
            vuv = uv;
            gl_Position = vec4(position, 0.0, 1.0);
        }
    |]


fragmentShader : Shader {} Uniforms Varyings
fragmentShader =
    [glsl|
        precision highp float;

        uniform float time;
        uniform vec2 scale;
        uniform vec2 coord;

        varying vec2 vuv;
        
        vec3 hsl2rgb(vec3 c) {
            vec3 rgb = clamp(abs(mod(c.x*6.0 + vec3(0.0, 4.0, 2.0), 6.0)-3.0)-1.0, 0.0, 1.0);
            return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
        }

        void main () {
            vec2 c = coord + (vuv-0.5) * scale;
            vec2 z = vec2(0.);
            float iter = 0.0;
            for (int i = 0; i < 256; i++) {
                z = vec2(z.x*z.x-z.y*z.y, 2.*z.x*z.y) + c;
                if (length(z) > 2.) break;
                iter += 1.;
            }
            
            vec3 color = hsl2rgb(vec3(iter / 24., 1., 0.5));
            gl_FragColor = vec4(color, 1.);
        }
    |]
