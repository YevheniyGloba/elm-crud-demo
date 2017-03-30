module Update exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)

import Model exposing (..)

import Person.Update as PersonUpdate
import User.Update as UserUpdate

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnLocationChange location ->
      locationChangeHandler model location

    NavbarMsg state ->
      { model | navbarState = state } ! []

    PersonMsg personMsg ->
      let
        (personModel, cmd) =
          PersonUpdate.update personMsg model.personModel
      in
        {model | personModel = personModel } ! [Cmd.map PersonMsg cmd]

    UserMsg userMsg ->
      let
        (userModel, cmd) =
          UserUpdate.update userMsg model.userModel
      in
        {model | userModel = userModel } ! [Cmd.map UserMsg cmd]



locationChangeHandler : Model -> Location -> (Model, Cmd Msg)
locationChangeHandler model location =
  let
    newRoute =
        parseLocation location
  in
    case newRoute of
      PersonRoute route ->
        let
          (personModel, personMsg) =
            PersonUpdate.changeRouteHandler model.personModel route
        in
          {model |
            route = newRoute,
            personModel = personModel
          } ! [Cmd.map PersonMsg personMsg]

      UserRoute route ->
        let
          (userModel, userMsg) =
            UserUpdate.changeRouteHandler model.userModel route
        in
        ({model | route = newRoute, userModel = userModel}, Cmd.map UserMsg userMsg)
      _ ->
        {model | route = newRoute} ! []


parseLocation: Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route ->
      route
    Nothing ->
      NotFound
