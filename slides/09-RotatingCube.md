## Cube Example

[View on Ellie](https://ellie-app.com/7STFkQjmNa1/1)

Notes:

This next part is going to go really fast and introduce a lot of new concepts. The goal is to just let you know that these concepts exist and you can go explore them on your own if you choose.

---


### Time & Animation

```elm
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }
```

```elm
import AnimationFrame
import Time

type Msg
    = Toggle
    | Animate Time 

subscriptions : Model -> Sub Msg
subscriptions _ = AnimationFrame.diffs Animate -- delta-t
```

Notes:

`model` has been replaced by `init` in `Html.program`.

Underscore used to denote unused arguments.

Subscriptions are listening to the outside world. It's how we get effectful things into out code. Subscriptions are for talking to servers, mouse/keyboard input, time.

---


### Commands & Update

```elm
type alias Model = { toggle : Bool , theta : Float }

init : (Model, Cmd msg)
init =
    ( { toggle = False , theta = 0 }, Cmd.none )

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
        Toggle ->
            ( { model | toggle = not model.toggle }, Cmd.none )
        Animate dt ->
            ( { model | theta = model.theta + dt / 5000 }, Cmd.none )
```

Notes:

We're not using any, so just `Cmd.none`. You might want to look it up later.

Tell the runtime to execute things that involve side-effects. It's how we have an effect on the outside world. Commands are for making requests, managing localStorage, random numbers.

Update a record syntax.

---


### Camera & Perspective

```elm
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
```

Notes:

Linear algebra!

Useful helpers for creating rotation, perspective, and lookAt matrices.

This is spinning the cube based on out current time, theta, on the Y and X axies.

`makeRotate`: radians axis

`makePerspective`:
- fovy: field of view in the y axis, in degrees
- aspect: aspect ratio
- znear: the near z distance of the projection
- zfar: the far z distance of the projection

`makeLookAt`:
- eye: The location of the camera
- center: The location of the focused object
- up: The "up" direction according to the camera

---


### Face-Colored Cube

```elm
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
```

Notes:

We don't have a good model loader in Elm yet, so you have to build all your meshes from math. This is why most Elm WebGL examples are 2D games. They only require creating squares which we already did.

Let syntax to reuse the result of an expression. Basically just a substitution.



---

<div class="demo elm-cube"></div>
