module Request.Person
    exposing
        ( get
        )

import Data.Person as Person exposing (Person)
import Http
import HttpBuilder exposing (RequestBuilder, withBody, withExpect, withQueryParams)
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Errored exposing (PageLoadError)
import Request.Helpers exposing (apiUrl)
import Task exposing (Task)


-- SINGLE --


get : String -> Task Http.Error Person
get id =
    let
        expect =
            Person.decoder
                |> Http.expectJson
    in
        apiUrl ("/people/" ++ id)
            |> HttpBuilder.get
            |> HttpBuilder.withExpect expect
            |> HttpBuilder.toRequest
            |> Http.toTask
