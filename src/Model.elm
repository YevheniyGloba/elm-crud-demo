module Model exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Bootstrap.Navbar as Navbar

import Person.Model as PersonModel
import User.Model as UserModel

type Route
  = Main
  | PersonRoute PersonModel.Route
  | UserRoute UserModel.Route
  | ParamPage Int
  | NotFound

type alias Model =
  {
    navbarState: Navbar.State,
    route: Route,
    personModel: PersonModel.Model,
    userModel: UserModel.Model
  }

type Msg
  = OnLocationChange Location
  | PersonMsg PersonModel.Msg
  | UserMsg UserModel.Msg
  | NavbarMsg Navbar.State


initModel : Route -> (Model, Cmd Msg)
initModel route =
  let
    (navbarState, navbarCmd) =
      Navbar.initialState NavbarMsg
  in
    Model navbarState route PersonModel.initPersonModel UserModel.initModel ! [navbarCmd]


matchers: Parser (Route -> a) a
matchers =
  oneOf
    [ UrlParser.map Main top
    , UrlParser.map ParamPage (UrlParser.s "param" </> UrlParser.int)
    , UrlParser.map PersonRoute PersonModel.matchers
    , UrlParser.map UserRoute UserModel.matchers
    ]
