module User.View exposing (..)

import Html exposing (..)

import User.Model exposing (..)

userView: Model -> Route -> Html Msg
userView model route =
  case route of
    UserListRoute ->
      userListView model
    UserReadRoute userId ->
      userReadView model


userListView: Model -> Html Msg
userListView model =
  div [] [text "user list view"]

userReadView: Model -> Html Msg
userReadView model =
  div [] [text "user read view"]
