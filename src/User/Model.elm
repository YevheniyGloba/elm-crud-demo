module User.Model exposing (..)

import UrlParser exposing (..)
import Http

-- Routing
type Route
  = UserListRoute
  | UserReadRoute UserId

matchers: Parser (Route -> a) a
matchers =
  oneOf
    [ UrlParser.map UserListRoute (UrlParser.s "users")
    , UrlParser.map UserReadRoute (UrlParser.s "user" </> UrlParser.int)
    ]

-- Msg
type Msg
  = GetUserHandler (Result Http.Error User)
  | UserListHandler (Result Http.Error (List User))

-- Model

type alias FullName = String
type alias Email = String
type alias Age = Int
type alias UserId = Int

type alias User = {
  id: UserId,
  fullname: String,
  email: String,
  age: Int
}

initUser: UserId -> FullName -> Email -> Age -> User
initUser userId fullname email age =
  User userId fullname email age

initEmptyUser: User
initEmptyUser =
  User 0 "" "" 0

type alias Model = {
  userList: Maybe (List User),
  user: Maybe User
}

initModel: Model
initModel =
  Model Nothing Nothing
