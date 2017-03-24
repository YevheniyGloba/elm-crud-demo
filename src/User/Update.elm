module User.Update exposing (..)

import User.Model exposing (..)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    _ -> model ! []

routeChangeHandler: Model -> Route -> (Model, Cmd Msg)
routeChangeHandler model route =
  case route of
    UserListRoute ->
      model ! []
    UserReadRoute userId ->
      model ! []
