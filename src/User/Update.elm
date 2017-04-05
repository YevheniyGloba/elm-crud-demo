module User.Update exposing (..)

import User.Model exposing (..)
import User.Rest as Rest
import Navigation

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadUserList ->
      (model, Cmd.none)

    HandleUserList (Ok userList) ->
      ({model | userList = (List.append model.userList userList)}, Cmd.none)

    HandleUser (Ok user) ->
      ({model | user = user}, Cmd.none)

    HandleFullNameInput str ->
      let
        user = model.user
        newUser = {user | fullName = str}
      in
      ({model | user = newUser}, Cmd.none)

    HandleEmailInput str ->
          let
            user = model.user
            newUser = {user | email = str}
          in
          ({model | user = newUser}, Cmd.none)

    HandleAgeInput str ->
          let
            user = model.user
            newUser = {user | age = Result.withDefault 0 (String.toInt str)}
          in
          ({model | user = newUser}, Cmd.none)

    SubmitUserEdit user ->
      (model, Rest.updateUser user)

    SubmitUserCreate user ->
      (model, Rest.createUser user)

    CreateUser ->
      (model, Navigation.newUrl "#/users/create")

    DeleteUser user ->
      (model, Rest.deleteUser user)

    HandleUserDelete (Ok ()) ->
      (model, Navigation.newUrl "#/users/")

    HandleUserCreate (Ok ()) ->
      (model, Navigation.newUrl "#/users/")

    HandleUserUpdate (Ok ()) ->
          (model, Navigation.newUrl "#/users/")

    _ -> (model, Cmd.none)

changeRouteHandler : Model -> Route -> (Model, Cmd Msg)
changeRouteHandler model route =
  case route of
    UserRoute personId ->
      (model, (Rest.getUser personId))

    UserListRoute ->
      ({model | userList = []}, Rest.getList)

    EditUserRoute id ->
      (model, (Rest.getUser id))

    CreateUserRoute ->
      ({model | user = initUser}, Cmd.none)

