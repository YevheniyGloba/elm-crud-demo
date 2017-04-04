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
  | CreateUser
  | HandleUserList (Result Http.Error (List User))
  | HandleUser (Result Http.Error User )
  | HandleUserUpdate (Result Http.Error ())
  | HandleUserDelete (Result Http.Error ())
  | HandleUserCreate (Result Http.Error ())
  | EditUser User
  | SubmitUserEdit User
  | SubmitUserCreate User
  | HandleUserFullName String
  | HandleUserEmail String
  | HandleUserAge String
  | DeleteUser User


type Route
  = UserRoute UserId
  | UserListRoute
  | EditUserRoute Int
  | CreateUserRoute

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
    , UrlParser.map EditUserRoute (UrlParser.s "user" </> UrlParser.int </> UrlParser.s "edit")
    , UrlParser.map CreateUserRoute (UrlParser.s "users" </> UrlParser.s "create")
    ]


