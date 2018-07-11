module Page.Person exposing (Model, Msg, init, update, view)

import Data.Person as Person exposing (Person)
import Date exposing (Date)
import Date.Format
import Html exposing (..)
import Html.Attributes exposing (attribute, class, disabled, href, id, placeholder)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.Person
import Route
import Task exposing (Task)
import Views.Person
import Views.Page as Page


-- MODEL --


type alias Model =
    { errors : List String
    , person : Person
    }


init : String -> Task PageLoadError Model
init id =
    let
        loadPerson =
            Request.Person.get id

        handleLoadError _ =
            pageLoadError Page.Other "Person is currently unavailable."
    in
        Task.map (Model []) loadPerson
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    let
        person =
            model.person
    in
        div [ class "person-page" ]
            [ div [ class "container page" ]
                [ div [ class "row person-content" ]
                    [ div [ class "col-md-12" ]
                        [ text person.name ]
                    ]
                ]
            ]



-- UPDATE --


type Msg
    = DismissErrors


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        person =
            model.person
    in
        case msg of
            DismissErrors ->
                ( { model | errors = [] }, Cmd.none )
