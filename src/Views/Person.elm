module Views.Person exposing (view)

import Data.Person exposing (Person)
import Date.Format
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder, src)
import Route exposing (Route)


-- VIEWS --


view : (Person -> msg) -> Person -> Html msg
view toggleFavorite person =
    div [ class "person-preview" ]
        [ a [ class "preview-link", Route.href (Route.Person "1") ]
            [ h1 [] [ text person.name ]
            , p [] [ text person.mass ]
            , span [] [ text "Read more..." ]
            ]
        ]
