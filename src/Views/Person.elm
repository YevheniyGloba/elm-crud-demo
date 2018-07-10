module Views.Person exposing (view, viewTimestamp)

{-| Viewing a preview of an individual person, excluding its body.
-}

import Data.Person exposing (Person)
import Date.Format
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder, src)
import Route exposing (Route)


-- VIEWS --


{-| Some pages want to view just the timestamp, not the whole person.
-}
viewTimestamp : Person a -> Html msg
viewTimestamp person =
    span [ class "date" ] [ text (formattedTimestamp person) ]


view : (Person a -> msg) -> Person a -> Html msg
view toggleFavorite person =
    let
        author =
            person.author
    in
    div [ class "person-preview" ]
        [ a [ class "preview-link", Route.href (Route.Person person.slug) ]
            [ h1 [] [ text person.title ]
            , p [] [ text person.description ]
            , span [] [ text "Read more..." ]
            ]
        ]



-- INTERNAL --


formattedTimestamp : Person a -> String
formattedTimestamp person =
    Date.Format.format "%B %e, %Y" person.createdAt
