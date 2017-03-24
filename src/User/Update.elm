module User.Update exposing (..)

import Http
import Json.Decode as Decode

import User.Model exposing (..)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetUserHandler (Ok user) ->
      {model | user = Just user} ! []
    GetUserHandler (Err err) ->
      {model | user = Nothing} ! []
    UserListHandler (Ok userList) ->
      {model | userList = Just userList} ! []
    UserListHandler (Err err) ->
      {model | userList = Nothing} ! []

routeChangeHandler: Model -> Route -> (Model, Cmd Msg)
routeChangeHandler model route =
  case route of
    UserListRoute ->
      model ! [getUserList]
    UserReadRoute userId ->
      model ! [getUser userId]

getUserList: Cmd Msg
getUserList =
  let
    url = "/api/users"
  in
    Http.send UserListHandler (Http.get url userListDecoder)

getUser: UserId -> Cmd Msg
getUser userId =
  let
    url = "/api/users/" ++ (toString userId)
  in
    Http.send GetUserHandler (Http.get url userDecoder)

userListDecoder: Decode.Decoder (List User)
userListDecoder =
  Decode.at ["data"] (Decode.list userListItemDecoder)

userListItemDecoder: Decode.Decoder User
userListItemDecoder =
  Decode.map4 User
    (Decode.at ["id"] Decode.int)
    (Decode.at ["fullname"] Decode.string)
    (Decode.at ["email"] Decode.string)
    (Decode.at ["age"] Decode.int)

userDecoder: Decode.Decoder User
userDecoder =
  Decode.map4 User
    (Decode.at ["data", "id"] Decode.int)
    (Decode.at ["data", "fullname"] Decode.string)
    (Decode.at ["data", "email"] Decode.string)
    (Decode.at ["data", "age"] Decode.int)
