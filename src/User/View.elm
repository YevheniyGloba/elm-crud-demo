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
  case model.userList of
    Just userList ->
      div [] (List.map userTableItem userList)
    Nothing ->
      div [] [text "Loading..."]

userTableItem: User -> Html Msg
userTableItem user =
  div [] [text user.fullname]

userReadView: Model -> Html Msg
userReadView model =
  case model.user of
    Just user ->
      div [] [text (toString user.fullname)]
    Nothing ->
      div [] [text "Loading..."]
