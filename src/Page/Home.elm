module Page.Home exposing (Model, Msg, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder)
import Html.Events exposing (onClick)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Task exposing (Task)
import Views.Page as Page


-- MODEL --


type alias Model =
    { homeText : String
    }


init : Task PageLoadError Model
init =
    let
        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable."
    in
        Task.succeed (Model "Your first elm project")
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p [] [ text "Popular Tags" ]
                        ]
                    ]
                ]
            ]
        ]



-- UPDATE --


type Msg
    = SomeMessage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SomeMessage ->
            ( model, Cmd.none )
