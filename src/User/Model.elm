module User.Model exposing (..)

import UrlParser exposing (..)
import Http

type alias UserId = Int

type alias User =
  {
    id: Int,
    fullName: String,
    email: String,
    age: Int
  }

type alias Model =
  { userList: List User
  , user: User
  }

type Msg
  = LoadUserList
  | HandleUserList (Result Http.Error (List User))
{-
  | LoadUser Int
  | HandleUser (Result Http.Error User )
-}

type Route
  = UserRoute UserId
  | UserListRoute

initUserModel : Model
initUserModel =
  Model [] initUser

initUser : User
initUser =
  User 0 "" "" 0

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ UrlParser.map UserListRoute (UrlParser.s "users")
    , UrlParser.map UserRoute (UrlParser.s "user" </> UrlParser.int)
    ]
