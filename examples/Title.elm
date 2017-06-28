module Title exposing (..)

import Html exposing (code, div, h1, pre, span, text)
import Html.Attributes exposing (class)


main =
    Html.beginnerProgram
        { model = { title = "WebGL in Elm", subtitle = "Alex Lende" }
        , view =
            (\model ->
                div [ class "demo" ]
                    [ h1 [] [ text model.title ]
                    , span [] [ text model.subtitle ]
                    ]
            )
        , update = (\model -> model)
        }
