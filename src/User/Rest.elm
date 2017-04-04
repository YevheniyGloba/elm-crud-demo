module User.Rest exposing (..)

import Http
import User.Model exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode

getUserList : Cmd Msg
getUserList =
   let
      url = "/api/users"
    in
      Http.send HandleUserList (Http.get url decodeUsers)

getUser : Int -> Cmd Msg
getUser id =
  let
    url = "/api/users/" ++ (toString id)
  in
    Http.send HandleUser (Http.get url decodeUser)

updateUser : User -> Cmd Msg
updateUser user =
  let
    url = "/api/users/" ++ (toString user.id)
    body = jsonUserBody user
  in
    Http.send HandleUserUpdate (put url body)

createUser : User -> Cmd Msg
createUser user =
  let
    url = "/api/users/"
    body = jsonUserBody user
  in
    Http.send HandleUserCreate (post url body)

deleteUser : User -> Cmd Msg
deleteUser user =
  let
    url = "/api/users/" ++ (toString user.id)
  in
    Http.send HandleUserDelete (delete url Http.emptyBody)


put : String -> Http.Body -> Http.Request ()
put url body =
  Http.request
    { method = "PUT"
    , headers = []
    , url = url
    , body = body
    , expect = Http.expectStringResponse (\_ -> Ok ())
    , timeout = Nothing
    , withCredentials = False
    }

delete : String -> Http.Body -> Http.Request ()
delete url body =
  Http.request
    { method = "DELETE"
    , headers = []
    , url = url
    , body = body
    , expect = Http.expectStringResponse (\_ -> Ok ())
    , timeout = Nothing
    , withCredentials = False
    }

post : String -> Http.Body -> Http.Request ()
post url body =
  Http.request
    { method = "POST"
    , headers = []
    , url = url
    , body = body
    , expect = Http.expectStringResponse (\_ -> Ok ())
    , timeout = Nothing
    , withCredentials = False
    }

jsonUserBody : User -> Http.Body
jsonUserBody user =
  let
    encodedUser = encodeUser user
    stringifiedUser = Encode.encode 0 (Encode.object [ ("user", encodedUser)])
  in
  Http.stringBody "application/json" (stringifiedUser)

encodeUser : User -> Encode.Value
encodeUser user =
  Encode.object [("id", Encode.int user.id)
                , ("fullname", Encode.string user.fullName)
                , ("email", Encode.string user.email)
                , ("age", Encode.int user.age)
                ]

decodeUsers : Decode.Decoder (List User)
decodeUsers =
  Decode.at ["data"] (Decode.list userDecoder)

decodeUser : Decode.Decoder User
decodeUser =
  Decode.at ["data"] userDecoder

userDecoder : Decode.Decoder User
userDecoder =
  Decode.map4 User
    (Decode.at ["id"] Decode.int)
    (Decode.at ["fullname"] Decode.string)
    (Decode.at ["email"] Decode.string)
    (Decode.at ["age"] Decode.int)
