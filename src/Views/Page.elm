module Views.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy2)
import Route exposing (Route)


type ActivePage
    = Home
    | Other


frame : Bool -> ActivePage -> Html msg -> Html msg
frame isLoading page content =
    div [ class "page-frame" ]
        [ viewHeader
        , content
        ]


viewHeader : Html msg
viewHeader =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ ul [ class "nav navbar-nav pull-xs-right" ]
                [ li [ classList [ ( "nav-item", True ) ] ]
                    [ a [ class "nav-link", Route.href Route.Home ] [ text "HOME" ] ]
                , li [ classList [ ( "nav-item", True ) ] ]
                    [ a [ class "nav-link", Route.href (Route.Person "1") ] [ text "Person" ] ]
                ]
            ]
        ]
