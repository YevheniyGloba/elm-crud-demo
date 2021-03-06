module Main exposing (main)

import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Page.Person as Person
import Data.Person as PersonModel
import Page.Errored as Errored exposing (PageLoadError)
import Page.Home as Home
import Route exposing (Route)
import Task
import Views.Page as Page exposing (ActivePage)


type Page
    = Home Home.Model
    | Person Person.Model
    | Errored PageLoadError


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { pageState : PageState
    }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded (Home (Home.Model "some text"))
        }



-- VIEW --


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            Page.frame isLoading
    in
        case page of
            Home subModel ->
                Home.view subModel
                    |> frame Page.Home
                    |> Html.map HomeMsg

            Person subModel ->
                Person.view subModel
                    |> frame Page.Other
                    |> Html.map PersonMsg

            Errored subModel ->
                Errored.view subModel
                    |> frame Page.Other



-- SUBSCRIPTIONS --
-- Note: we aren't currently doing any page subscriptions, but I thought it would
-- be a good idea to put this in here as an example. If I were actually
-- maintaining this in production, I wouldn't bother until I needed this!


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        ]


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Home _ ->
            Sub.none

        Person _ ->
            Sub.none

        Errored _ ->
            Sub.none



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | HomeMsg Home.Msg
    | PersonMsg Person.Msg
    | HomeLoaded (Result PageLoadError Home.Model)
    | PersonLoaded (Result PageLoadError Person.Model)


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , Task.attempt toMsg task
            )

        errored =
            pageErrored model
    in
        case maybeRoute of
            Nothing ->
                ( { model | pageState = Loaded (Home (Home.Model "some text")) }, Cmd.none )

            Just Route.Home ->
                transition HomeLoaded (Home.init)

            Just (Route.Person id) ->
                transition PersonLoaded (Person.init id)


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        ( { model | pageState = Loaded (Errored error) }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( HomeLoaded (Ok subModel), _ ) ->
                ( { model | pageState = Loaded (Home subModel) }, Cmd.none )

            ( HomeLoaded (Err error), _ ) ->
                ( { model | pageState = Loaded (Errored error) }, Cmd.none )

            ( PersonLoaded (Ok subModel), _ ) ->
                ( { model | pageState = Loaded (Person subModel) }, Cmd.none )

            ( PersonLoaded (Err error), _ ) ->
                ( { model | pageState = Loaded (Errored error) }, Cmd.none )

            ( _, _ ) ->
                -- Disregard incoming messages that arrived for the wrong page
                ( model, Cmd.none )



-- MAIN --


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
