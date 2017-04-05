module User.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Bootstrap.Form as Form
import Bootstrap.Button as Button

import User.Model exposing (..)

view : Model -> Route -> Html Msg
view model route =
  case route of
    UserRoute userId ->
      userView userId model
    UserListRoute ->
      userListView model
    EditUserRoute id->
      userEditForm model
    CreateUserRoute ->
      createUserForm model

userView : UserId -> Model -> Html Msg
userView userId model =
  Grid.row []
    [ Grid.col [Col.xs12] [h1 [] [text ("User " ++ toString userId)]]
    , Grid.col [Col.xs12] [userForm model]
    ]

userForm : Model -> Html Msg
userForm model =
  let
    user = model.user
  in
  Form.form []
  [ Form.row []
    [ Form.colLabel [Col.xs3] [text "Full name"]
    , Form.colLabel [Col.xs3]
        [p [] [text user.fullName]
        ]
    ]
  , Form.row []
    [ Form.colLabel [Col.xs3] [text "E-mail"]
    , Form.colLabel [Col.xs3]
        [ p [][text user.email]
        ]
    ]
  , Form.row []
    [ Form.colLabel [Col.xs3] [text "Age"]
    , Form.colLabel [Col.xs3]
        [ p [style [("color", "red")]][text (toString user.age)]
        ]
    ]
  , a [class "btn btn-primary", href ("#/user/" ++ (toString user.id) ++ "/edit" )][text "Edit user details"]
  ]

userRow : Int -> User -> Table.Row Msg
userRow index user =
  Table.tr []
    [ Table.td [] [text user.fullName]
    , Table.td [] [text user.email]
    , Table.td [] [text (toString user.age)]
    , Table.td [] [
        a [class "btn btn-primary", href ("#/user/" ++ (toString user.id)) ] [text "Details"]
      ]
    , Table.td [] [
       Button.button
        [ Button.primary
          , Button.attrs [onClick (DeleteUser user)]
          ]
        [text "Delete"]
      ]
    ]


userListView : Model -> Html Msg
userListView model =
  div []
    [ Grid.row []
        [ Grid.col [Col.xs12] [h1 [] [text "User list"]] ]
      , Grid.row []
        [ Grid.col [Col.xs12]
          [
            Table.table
              { options = [ Table.striped, Table.bordered ]
              , thead = Table.simpleThead
                        [ Table.th [] [text "Full name"]
                        , Table.th [] [text "Email"]
                        , Table.th [] [text "Age"]
                        , Table.th [] []
                        ]
              , tbody = Table.tbody [] (List.indexedMap userRow model.userList)
              }
          ]
          , Grid.col [Col.xs3]
            [ Button.button
             [ Button.primary
               , Button.attrs [onClick LoadUserList]
               ]
             [text "Load more"]
            ]
          , Grid.col [Col.xs3]
            [ Button.button
             [ Button.primary
               , Button.attrs [onClick CreateUser]
               ]
             [text "Create new user"]
            ]
        ]
    ]

userEditForm : Model -> Html Msg
userEditForm model =
  let
    user = model.user
  in
  div []
    [ h1 [] [text "Edit user page"]
    , Form.form []
        [ Form.row []
          [ Form.colLabel [Col.xs3] [text "Full name"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue user.fullName, onInput HandleFullNameInput] []
              ]
          ]
        , Form.row []
          [ Form.colLabel [Col.xs3] [text "E-mail"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue user.email, onInput HandleEmailInput] []
              ]
          ]
        , Form.row []
          [ Form.colLabel [Col.xs3] [text "Age"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue (toString user.age), onInput HandleAgeInput] []
              ]
          ]
        , Button.button
          [ Button.primary
            , Button.attrs [onClick (SubmitUserEdit user)]
            ]
          [text "Submit"]
         ]
    ]

createUserForm : Model -> Html Msg
createUserForm model =
  let
    user = model.user
  in
  div []
    [ h1 [] [text "Create user page"]
    , Form.form []
        [ Form.row []
          [ Form.colLabel [Col.xs3] [text "Full name"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue user.fullName, onInput HandleFullNameInput] []
              ]
          ]
        , Form.row []
          [ Form.colLabel [Col.xs3] [text "E-mail"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue user.email, onInput HandleEmailInput] []
              ]
          ]
        , Form.row []
          [ Form.colLabel [Col.xs3] [text "Age"]
          , Form.colLabel [Col.xs3]
              [input [defaultValue (toString user.age), onInput HandleAgeInput] []
              ]
          ]
        , Button.button
          [ Button.primary
            , Button.attrs [onClick (SubmitUserCreate user)]
            ]
          [text "Submit"]
         ]
    ]
