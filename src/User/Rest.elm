module User.Rest exposing (..)

import Http
import User.Model exposing (..)
import Json.Decode as Decode

getUserList : Cmd Msg
getUserList =
   let
      url = "/api/users"
    in
      Http.send HandleUserList (Http.get url decodeUsers)

decodeUsers : Decode.Decoder (List User)
decodeUsers =
  Decode.at ["data"] (Decode.list userDecoder)

userDecoder : Decode.Decoder User
userDecoder =
  Decode.map4 User
    (Decode.at ["id"] Decode.int)
    (Decode.at ["fullname"] Decode.string)
    (Decode.at ["email"] Decode.string)
    (Decode.at ["age"] Decode.int)