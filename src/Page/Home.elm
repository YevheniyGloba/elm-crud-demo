module Page.Home exposing (Model, Msg, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder)
import Html.Events exposing (onClick)
import Http
import Request.Person
import SelectList exposing (SelectList)
import Task exposing (Task)
import Views.Page as Page


-- MODEL --


type alias Model =
    { person : Person.Model
    }


init : Session -> Task PageLoadError Model
init session =
    let

        loadSources =
            Person.init

        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable."
    in
    Task.map Model loadSources
        |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ viewBanner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ] (viewFeed model.feed)
                , div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p [] [ text "Popular Tags" ]
                        , viewTags model.tags
                        ]
                    ]
                ]
            ]
        ]


viewBanner : Html msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "conduit" ]
            , p [] [ text "A place to share your knowledge." ]
            ]
        ]


viewFeed : Feed.Model -> List (Html Msg)
viewFeed feed =
    div [ class "feed-toggle" ]
        [ Feed.viewFeedSources feed |> Html.map FeedMsg ]
        :: (Feed.viewArticles feed |> List.map (Html.map FeedMsg))



-- UPDATE --


type Msg
    = FeedMsg Feed.Msg


update :  Msg -> Model -> ( Model, Cmd Msg )
update  msg model =
    case msg of
        FeedMsg subMsg ->
            let
                ( newFeed, subCmd ) =
                    Feed.update session subMsg model.feed
            in
            { model | feed = newFeed } => Cmd.map FeedMsg subCmd

