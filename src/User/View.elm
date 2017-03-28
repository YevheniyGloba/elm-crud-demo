module User.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Bootstrap.Form as Form
-- import Bootstrap.Form.Input as Input
import Form.Input as Input
import Form exposing (Form)

import Bootstrap.Button as Button

import User.Model exposing (..)

userView: Model -> Route -> Html Msg
userView model route =
  div [] [
  case route of
    UserListRoute ->
      userListView model
    UserReadRoute userId ->
      userReadView model
    UserCreateRoute ->
      userCreateView model
  , div [] [text (toString model)]
  ]

-- User List View

userListView: Model -> Html Msg
userListView model =
  case model.userList of
    Just userList ->
      userTable userList
    Nothing ->
      div [] [text "Loading..."]

userTable: List User -> Html Msg
userTable userList =
    Grid.row []
      [ Grid.col [Col.xs12] [h1 [] [text "User list"]]
      , Grid.col [Col.xs12]
        [ Button.linkButton
          [ Button.primary
          , Button.attrs [href linkForCreateUser]
          ]
          [text "New user"]
        ]
      , Grid.col [Col.xs12]
        [
          Table.table
          { options = [ Table.striped ]
          , thead = Table.simpleThead
                    [ Table.th [] [text "id"]
                    , Table.th [] [text "fullname"]
                    , Table.th [] [text "email"]
                    , Table.th [] [text "age"]
                    , Table.th [] [text "lalka"]
                    ]
          , tbody = Table.tbody [] (List.map userTableRow userList)
          }
        ]
      ]

userTableRow: User -> Table.Row Msg
userTableRow user =
  Table.tr []
    [ Table.td [] [text (toString user.id)]
    , Table.td [] [text user.fullname]
    , Table.td [] [text user.email]
    , Table.td [] [text (toString user.age)]
    , Table.td []
        [a [href <| linkForUser <| user.id] [text "details"]]
    ]

-- User Read View

userReadView: Model -> Html Msg
userReadView model =
  case model.user of
    Just user ->
      div [] [text (toString user.fullname)]
    Nothing ->
      div [] [text "Loading..."]

-- User Create View

userCreateView: Model -> Html Msg
userCreateView model =
  Grid.row [] [
    Grid.col [Col.xs12] [h1 [] [text "Create user"]],
    Grid.col [Col.xs12] [userCreateForm model]
  ]

userCreateForm: Model -> Html Msg
userCreateForm model =
  Form.form [] [
    Html.map CreateFormMsg (fullnameRow model),
    Html.map CreateFormMsg (emailRow model),
    Html.map CreateFormMsg (ageRow model),
    Html.map CreateFormMsg (submitRow model)
  ]

fullnameRow: Model -> Html Form.Msg
fullnameRow model =
  let
    fullname =
      Form.getFieldAsString "fullname" model.createUserForm
  in
    Form.row [] [
      Form.colLabel [Col.xs3] [text "fullname"],
      Form.col [Col.xs9] [
        Input.textInput fullname [class "form-control"]
      ]
    ]

emailRow: Model -> Html Form.Msg
emailRow model =
  let
    email =
      Form.getFieldAsString "email" model.createUserForm
  in
    Form.row [] [
      Form.colLabel [Col.xs3] [text "email"],
      Form.col [Col.xs9] [
        Input.textInput email [class "form-control"]
      ]
    ]

ageRow: Model -> Html Form.Msg
ageRow model =
  let
    age =
      Form.getFieldAsString "age" model.createUserForm
  in
    Form.row [] [
      Form.colLabel [Col.xs3] [text "age"],
      Form.col [Col.xs9] [
        Input.textInput age [class "form-control"]
      ]
    ]

submitRow: Model -> Html Form.Msg
submitRow model =
  Form.row [] [
    Form.col [Col.xs12] [
      Button.button
        [Button.primary, Button.attrs [onClick Form.Submit, type_ "button"]]
        [text "Create"]
    ],
    Form.col [Col.xs12] [
      Input.dumpErrors model.createUserForm
    ]
  ]
