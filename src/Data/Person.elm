module Data.Person
    exposing
        ( Person
        , Body
        , Tag
        , bodyToHtml
        , bodyToMarkdownString
        , decoder
        , decoderWithBody
        , tagDecoder
        , tagToString
        )

import Date exposing (Date)
import Html exposing (Attribute, Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Decode.Pipeline exposing (custom, decode, hardcoded, required)
import Markdown
import UrlParser

type alias Person a =
    { description : String
    , title : String
    , tags : List String
    , createdAt : Date
    , updatedAt : Date
    , favorited : Bool
    , favoritesCount : Int
    , body : a
    }



-- SERIALIZATION --


decoder : Decoder (Person ())
decoder =
    basePersonDecoder
        |> hardcoded ()


decoderWithBody : Decoder (Person Body)
decoderWithBody =
    basePersonDecoder
        |> required "body" bodyDecoder


basePersonDecoder : Decoder (a -> Person a)
basePersonDecoder =
    decode Person
        |> required "description" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "title" Decode.string
        |> required "tagList" (Decode.list Decode.string)
        |> required "createdAt" Json.Decode.Extra.date
        |> required "updatedAt" Json.Decode.Extra.date
        |> required "favorited" Decode.bool
        |> required "favoritesCount" Decode.int




-- TAGS --


type Tag
    = Tag String


tagToString : Tag -> String
tagToString (Tag slug) =
    slug


tagDecoder : Decoder Tag
tagDecoder =
    Decode.map Tag Decode.string



-- BODY --


type Body
    = Body Markdown


type alias Markdown =
    String


bodyToHtml : Body -> List (Attribute msg) -> Html msg
bodyToHtml (Body markdown) attributes =
    Markdown.toHtml attributes markdown


bodyToMarkdownString : Body -> String
bodyToMarkdownString (Body markdown) =
    markdown


bodyDecoder : Decoder Body
bodyDecoder =
    Decode.map Body Decode.string
