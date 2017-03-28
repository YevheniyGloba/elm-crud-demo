module User.Model exposing (..)

import UrlParser exposing (..)
import Http
import Form exposing (Form)
import Form.Validate

-- Routing
type Route
  = UserListRoute
  | UserReadRoute UserId
  | UserCreateRoute

linkForUserList: String
linkForUserList =
  "#users"

linkForUser: UserId -> String
linkForUser userId =
  "#user/" ++ (toString userId)

linkForCreateUser: String
linkForCreateUser =
  "#users/create"

matchers: Parser (Route -> a) a
matchers =
  oneOf
    [ UrlParser.map UserListRoute (UrlParser.s "users")
    , UrlParser.map UserReadRoute (UrlParser.s "user" </> UrlParser.int)
    , UrlParser.map UserCreateRoute (UrlParser.s "users" </> UrlParser.s "create")
    ]

-- Msg
type Msg
  = GetUserHandler (Result Http.Error User)
  | UserListHandler (Result Http.Error (List User))

-- Create new user
  | Fullname String
  | Email String
  | Age String
  | SubmitNewUser
  | CreateFormMsg Form.Msg

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
  user: Maybe User,
  createUser: User,
  isCreateUserValid: Bool,
  createUserForm: Form () User
}

initModel: Model
initModel =
  {
    userList = Nothing,
    user = Nothing,
    createUser = initEmptyUser,
    isCreateUserValid = True,
    createUserForm = Form.initial [] validation
  }

validation: Form.Validate.Validation () User
validation =
  Form.Validate.map4 User
    (Form.Validate.field "id"  Form.Validate.int)
    (Form.Validate.field "fullname"  Form.Validate.string)
    (Form.Validate.field "email"  Form.Validate.email)
    (Form.Validate.field "age"  Form.Validate.int)
