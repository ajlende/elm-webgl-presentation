## Toggling and Types

[View on Ellie](https://ellie-app.com/4Jv7RHmrta1/11)

Notes:

---


### Imports

```elm
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (width, height, type_)
import Html.Events exposing (onClick)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader, toHtml, entity, triangles)
```

Notes:


---


### Main

```elm
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }
```

Notes:


---


### Model

```elm
type alias Model = Bool

model : Model
model = False
```

Notes:


---


### View

```elm
type Msg = Toggle

view : Model -> Html Msg
view model =
    div []
        [ toHtml [ width 400, height 400 ]
            [ entity vertexShader fragmentShader mesh (uniforms model) ]
        , label []
            [ input [ type_ "checkbox", onClick Toggle ] []
            , text "Toggle"
            ]
        ]
```

Notes:


---


### Update

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle ->
            not model
```

Notes:


---


### Mesh

```elm
type alias Attributes =
    { position : Vec2
    , color : Vec3
    }

mesh : Mesh Attributes
mesh =
    triangles
        [ ( Attributes (vec2 -1 1) (vec3 1 0 0)
          , Attributes (vec2 -1 -1) (vec3 0 1 0)
          , Attributes (vec2 1 -1) (vec3 0 0 1)
          )
        ]
```

Notes:


---


### Uniforms

```elm
type alias Uniforms = { brightness : Float }

uniforms : Model -> Uniforms
uniforms model = { brightness = if model then 1 else 0 }
```

Notes:


---


### Vertex Shader

```elm
type alias Varyings =
    { vcolor : Vec3 }

vertexShader : Shader Attributes Uniforms Varyings
vertexShader = [glsl| ... |]
```

Notes:


---


### Fragment Shader

```elm
fragmentShader : Shader {} Uniforms Varyings
fragmentShader = [glsl| ... |]
```

Notes:


---


<div class="demo elm-toggle"></div>
