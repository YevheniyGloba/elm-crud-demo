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

userView : UserId -> Model -> Html Msg
userView userId model =
  Grid.row []
    [ Grid.col [Col.xs12] [h1 [] [text ("User " ++ toString userId)]]
    , Grid.col [Col.xs12] [userPaginator userId]
    , Grid.col [Col.xs12] [userForm model]
    ]

userForm : Model -> Html Msg
userForm model =
  let
    user = model.user
  in
  Form.form []
  [ Form.row []
    [ Form.colLabel [Col.xs3] [text "Name"]
    , Form.colLabel [Col.xs3]
        [p [] [text user.fullName]
--        , input [hidden (not model.editUserMode), value user.fullName, onInput (EditField "fullName")][]
        ]
    ]
  , Form.row []
    [ Form.colLabel [Col.xs3] [text "Height"]
    , Form.colLabel [Col.xs3]
        [ p [][text user.email]
--        , input [hidden (not model.editUserMode), defaultValue user.email][]
        ]
    ]
  , Form.row []
    [ Form.colLabel [Col.xs3] [text "Mass"]
    , Form.colLabel [Col.xs3]
        [ p [][text (toString user.age)]
--        , input [hidden (not model.editUserMode), defaultValue user.age][]
        ]
    ]
 {- , Form.row []
    [ Form.colLabel [Col.xs2] [button [class "btn btn-primary", onClick UserEdit][text "Edit"]]
    , Form.colLabel [Col.xs2] [button [class "btn btn-primary", hidden (not model.editUserMode)][text "Save"]]
    , Form.colLabel [Col.xs2] [button [class "btn btn-primary", hidden (not model.editUserMode), onClick UserEdit][text "Cancel"]]
    ]-}
  , Form.row []
    [ Form.colLabel [Col.xs12] [text (toString model.user)]]
  ]

userPaginator : UserId -> Html Msg
userPaginator userId =
  Grid.row []
    [ Grid.col [Col.xs4] [a [class "btn btn-primary", href ("#user/" ++ toString (userId-1))] [text ("User " ++ toString (userId-1))]]
    , Grid.col [Col.xs4] [a [class "btn btn-primary", href ("#user/" ++ toString (userId+1))] [text ("User " ++ toString (userId+1))]]
    ]

userRow : Int -> User -> Table.Row Msg
userRow index user =
  Table.tr []
    [ Table.td [] [text user.fullName]
    , Table.td [] [text user.email]
    , Table.td [] [text (toString user.age)]
    , Table.td [] [
        a [href ("#user/" ++ (toString (index+1))) ] [text "details"]
      ]
    ]


userListView : Model -> Html Msg
userListView model =
  div []
    [ Grid.row []
        [ Grid.col [Col.xs12] [h1 [] [text "User list"]] ]
      , Grid.row []
        [ Grid.col [Col.xs12]
          [ Button.button
             [ Button.primary
             , Button.attrs [onClick LoadUserList]
             ]
            [text "Load more"]
          ]
          ,  Grid.col
            [Col.xs12]
            [ text (toString model)]
          ,  Grid.col
            [Col.xs12]
            [ text (toString model.user)]

        ]

      {-, Grid.row []
          [ Grid.col [Col.xs12] [h1 [] [text (toString model.user)]] ]-}
    ]

 {- Grid.row []
    [ Grid.col [Col.xs12] [h1 [] [text "User list"]]
    , Grid.col [Col.xs12] [
        Table.table
        { options = [ Table.striped ]
        , thead = Table.simpleThead
                  [ Table.th [] [text "fullName"]
                  , Table.th [] [text "email"]
                  , Table.th [] [text "age"]
                  ]
        , tbody = Table.tbody [] (List.indexedMap userRow model.userList)
        }
      ]
    , Grid.col [Col.xs12]
      [ Button.button
          [ Button.primary
--          , Button.attrs [onClick (LoadUserList model.userListPageId)]
          ] [text "Load more"]
      ]
    ]-}
