module User.Update exposing (..)

import User.Model exposing (..)
import User.Rest as Rest
import Navigation

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadUserList ->
      (model, (Rest.getUser 1))

    HandleUserList (Ok userList) ->
      ({model | userList = (List.append model.userList userList)}, Cmd.none)

    HandleUser (Ok user) ->
      ({model | user = user}, Cmd.none)

    HandleUserEdit str ->
      let
        user = model.user
        newUser = {user | fullName = str}
      in
      ({model | user = newUser}, Rest.updateUser newUser)

    SubmitUserEdit user ->
      (model, Navigation.newUrl "#users")

    _ -> (model, Cmd.none)

changeRouteHandler : Model -> Route -> (Model, Cmd Msg)
changeRouteHandler model route =
  case route of
    UserRoute personId ->
      (model, (Rest.getUser personId))

    UserListRoute ->
      ({model | userList = []}, Rest.getUserList)

    EditUserRoute id ->
      (model, Cmd.none)

