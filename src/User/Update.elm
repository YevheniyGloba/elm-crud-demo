module User.Update exposing (..)

--import Http
--import Json.Decode as Decode

import User.Model exposing (..)
--import User.Rest as Rest
import Http
import Json.Decode as Decode

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadUserList ->
      ({model | user = User 2 "12" "12" 2}, getUserList)

    HandleUserList (Ok userList) ->
      ({model | userList = (List.append model.userList userList)}, Cmd.none)

    _ -> (model, Cmd.none)

changeRouteHandler : Model -> Route -> (Model, Cmd Msg)
changeRouteHandler model route =
  case route of
    UserRoute personId ->
      (model, Cmd.none)
    UserListRoute ->
      ({model | userList = []}, getUserList)


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
