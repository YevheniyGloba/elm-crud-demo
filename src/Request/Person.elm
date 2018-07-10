module Request.Person
    exposing
        ( FeedConfig
        , ListConfig
        , create
        , defaultFeedConfig
        , defaultListConfig
        , delete
        , feed
        , get
        , list
        , tags
        , toggleFavorite
        , update
        )

import Data.Person as Person exposing (Person, Body, Tag)
import Http
import HttpBuilder exposing (RequestBuilder, withBody, withExpect, withQueryParams)
import Json.Decode as Decode
import Json.Encode as Encode
import Request.Helpers exposing (apiUrl)


-- SINGLE --


get :  String -> Http.Request (Person Body)
get slug =
    let
        expect =
            Person.decoderWithBody
                |> Decode.field "person"
                |> Http.expectJson
    in
    apiUrl ("/persons/" ++ Person.slugToString slug)
        |> HttpBuilder.get
        |> HttpBuilder.withExpect expect
        |> withAuthorization maybeToken
        |> HttpBuilder.toRequest




