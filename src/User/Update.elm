module User.Update exposing (..)

import Result exposing (..)
import Http
import Json.Decode as Decode
import Form exposing (Form)

import User.Model exposing (..)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetUserHandler (Ok user) ->
      {model | user = Just user} ! []
    GetUserHandler (Err err) ->
      {model | user = Nothing} ! []
    UserListHandler (Ok userList) ->
      {model | userList = Just userList} ! []
    UserListHandler (Err err) ->
      {model | userList = Nothing} ! []

-- create new user
    Fullname fullname ->
      let
        createUser = model.createUser
      in
        {model | createUser = {createUser | fullname = fullname}} ! []
    Email email ->
      let
        createUser = model.createUser
      in
        {model | createUser = {createUser | email = email}} ! []
    Age age ->
      let
        createUser = model.createUser
      in
        {model | createUser = {createUser | age = (Result.withDefault 0 (String.toInt age))}} ! []

    SubmitNewUser ->
      let
        isUserValid = validateUser model.createUser
      in
        -- model ! (if isUserValid then createUser model.createUser else Cmd.none)
        {model | isCreateUserValid = isUserValid} ! (if isUserValid then [Cmd.none] else [Cmd.none])

    CreateFormMsg msg ->
      {model | createUserForm = Form.update validation msg model.createUserForm} ! [Cmd.none]

routeChangeHandler: Model -> Route -> (Model, Cmd Msg)
routeChangeHandler model route =
  case route of
    UserListRoute ->
      model ! [getUserList]
    UserCreateRoute ->
      model ! []
    UserReadRoute userId ->
      model ! [getUser userId]

getUserList: Cmd Msg
getUserList =
  let
    url = "/api/users"
  in
    Http.send UserListHandler (Http.get url userListDecoder)

getUser: UserId -> Cmd Msg
getUser userId =
  let
    url = "/api/users/" ++ (toString userId)
  in
    Http.send GetUserHandler (Http.get url userDecoder)

-- createUser: User -> Cmd Msg
-- createUser user =


userListDecoder: Decode.Decoder (List User)
userListDecoder =
  Decode.at ["data"] (Decode.list userListItemDecoder)

userListItemDecoder: Decode.Decoder User
userListItemDecoder =
  Decode.map4 User
    (Decode.at ["id"] Decode.int)
    (Decode.at ["fullname"] Decode.string)
    (Decode.at ["email"] Decode.string)
    (Decode.at ["age"] Decode.int)

userDecoder: Decode.Decoder User
userDecoder =
  Decode.map4 User
    (Decode.at ["data", "id"] Decode.int)
    (Decode.at ["data", "fullname"] Decode.string)
    (Decode.at ["data", "email"] Decode.string)
    (Decode.at ["data", "age"] Decode.int)


validateUser: User -> Bool
validateUser user =
  let
    (isFullnameValid, isEmailValid, isAgeValid) =
      (validateFullname user.fullname, validateEmail user.email, validateAge user.age)
  in
    isFullnameValid && isAgeValid && isAgeValid

validateFullname: String -> Bool
validateFullname fullname =
  (String.length fullname) < 5

validateEmail: String -> Bool
validateEmail email =
  (String.length email) < 5

validateAge: Int -> Bool
validateAge age =
  age > 0 && age < 100
