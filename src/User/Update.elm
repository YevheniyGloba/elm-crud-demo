module User.Update exposing (..)

--import Http
--import Json.Decode as Decode

import User.Model exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    _ -> (model, Cmd.none)

changeRouteHandler : Model -> Route -> (Model, Cmd Msg)
changeRouteHandler model route =
  case route of
    UserRoute personId ->
      model ! []
    UserListRoute ->
      { model
        | userList = []
      } ! []
