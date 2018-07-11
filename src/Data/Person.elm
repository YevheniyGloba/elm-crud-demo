module Data.Person
    exposing
        ( Person
        , decoder
        )

import Date exposing (Date)
import Html exposing (Attribute, Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra exposing ((|:))
import Json.Decode.Pipeline exposing (custom, decode, hardcoded, required)
import Markdown
import UrlParser


type alias Person =
    { name : String
    , mass : String
    }


decoder : Decoder Person
decoder =
    Decode.succeed
        Person
        |: Decode.field "name" Decode.string
        |: Decode.field "mass" Decode.string
