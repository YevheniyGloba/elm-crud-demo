module Page.Person exposing (Model, Msg, init, update, view)

{-| Viewing an individual person.
-}

import Data.Person as Person exposing (Person, Body)
import Date exposing (Date)
import Date.Format
import Html exposing (..)
import Html.Attributes exposing (attribute, class, disabled, href, id, placeholder)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Request.Person
import Route
import Task exposing (Task)
import Views.Person
import Views.Page as Page


-- MODEL --


type alias Model =
    { errors : List String
    , commentText : String
    , commentInFlight : Bool
    , person : Person Body
    }


init : String-> Task PageLoadError Model
init session slug =
    let
        maybeAuthToken =
            Maybe.map .token session.user

        loadPerson =
            Request.Person.get maybeAuthToken slug
                |> Http.toTask

        loadComments =
            Request.Person.Comments.list maybeAuthToken slug
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Other "Person is currently unavailable."
    in
    Task.map2 (Model [] "" False) loadPerson loadComments
        |> Task.mapError handleLoadError



-- VIEW --


view : Session -> Model -> Html Msg
view session model =
    let
        person =
            model.person

        author =
            person.author

        buttons =
            viewButtons person author session.user

        postingDisabled =
            model.commentInFlight
    in
    div [ class "person-page" ]
        [ viewBanner model.errors person author session.user
        , div [ class "container page" ]
            [ div [ class "row person-content" ]
                [ div [ class "col-md-12" ]
                    [ Person.bodyToHtml person.body [] ]
                ]
            , hr [] []
            , div [ class "person-actions" ]
                [ div [ class "person-meta" ] <|
                    [ a [ Route.href (Route.Profile author.username) ]
                        [ img [ UserPhoto.src author.image ] [] ]
                    , div [ class "info" ]
                        [ Views.Author.view author.username
                        , Views.Person.viewTimestamp person
                        ]
                    ]
                        ++ buttons
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-12 col-md-8 offset-md-2" ] <|
                    viewAddComment postingDisabled session.user
                        :: List.map (viewComment session.user) model.comments
                ]
            ]
        ]


viewBanner : List String -> Person a -> Author -> Maybe User -> Html Msg
viewBanner errors person author maybeUser =
    let
        buttons =
            viewButtons person author maybeUser
    in
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [] [ text person.title ]
            , div [ class "person-meta" ] <|
                [ a [ Route.href (Route.Profile author.username) ]
                    [ img [ UserPhoto.src author.image ] [] ]
                , div [ class "info" ]
                    [ Views.Author.view author.username
                    , Views.Person.viewTimestamp person
                    ]
                ]
                    ++ buttons
            , Views.Errors.view DismissErrors errors
            ]
        ]


viewAddComment : Bool -> Maybe User -> Html Msg
viewAddComment postingDisabled maybeUser =
    case maybeUser of
        Nothing ->
            p []
                [ a [ Route.href Route.Login ] [ text "Sign in" ]
                , text " or "
                , a [ Route.href Route.Register ] [ text "sign up" ]
                , text " to add comments on this person."
                ]

        Just user ->
            Html.form [ class "card comment-form", onSubmit PostComment ]
                [ div [ class "card-block" ]
                    [ textarea
                        [ class "form-control"
                        , placeholder "Write a comment..."
                        , attribute "rows" "3"
                        , onInput SetCommentText
                        ]
                        []
                    ]
                , div [ class "card-footer" ]
                    [ img [ class "comment-author-img", UserPhoto.src user.image ] []
                    , button
                        [ class "btn btn-sm btn-primary"
                        , disabled postingDisabled
                        ]
                        [ text "Post Comment" ]
                    ]
                ]


viewButtons : Person a -> Author -> Maybe User -> List (Html Msg)
viewButtons person author maybeUser =
    let
        isMyPerson =
            Maybe.map .username maybeUser == Just author.username
    in
    if isMyPerson then
        [ editButton person
        , text " "
        , deleteButton person
        ]
    else
        [ followButton author
        , text " "
        , favoriteButton person
        ]


viewComment : Maybe User -> Comment -> Html Msg
viewComment user comment =
    let
        author =
            comment.author

        isAuthor =
            Maybe.map .username user == Just comment.author.username
    in
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ p [ class "card-text" ] [ text comment.body ] ]
        , div [ class "card-footer" ]
            [ a [ class "comment-author", href "" ]
                [ img [ class "comment-author-img", UserPhoto.src author.image ] []
                , text " "
                ]
            , text " "
            , a [ class "comment-author", Route.href (Route.Profile author.username) ]
                [ text (User.usernameToString comment.author.username) ]
            , span [ class "date-posted" ] [ text (formatCommentTimestamp comment.createdAt) ]
            , viewIf isAuthor <|
                span
                    [ class "mod-options"
                    , onClick (DeleteComment comment.id)
                    ]
                    [ i [ class "ion-trash-a" ] [] ]
            ]
        ]


formatCommentTimestamp : Date -> String
formatCommentTimestamp =
    Date.Format.format "%B %e, %Y"



-- UPDATE --


type Msg
    = DismissErrors
    | ToggleFavorite
    | FavoriteCompleted (Result Http.Error (Person Body))
    | ToggleFollow
    | FollowCompleted (Result Http.Error Author)
    | SetCommentText String
    | DeleteComment CommentId
    | CommentDeleted CommentId (Result Http.Error ())
    | PostComment
    | CommentPosted (Result Http.Error Comment)
    | DeletePerson
    | PersonDeleted (Result Http.Error ())


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    let
        person =
            model.person

        author =
            person.author
    in
    case msg of
        DismissErrors ->
            { model | errors = [] } => Cmd.none

        ToggleFavorite ->
            let
                cmdFromAuth authToken =
                    Request.Person.toggleFavorite model.person authToken
                        |> Http.toTask
                        |> Task.map (\newPerson -> { newPerson | body = person.body })
                        |> Task.attempt FavoriteCompleted
            in
            session
                |> Session.attempt "favorite" cmdFromAuth
                |> Tuple.mapFirst (Util.appendErrors model)

        FavoriteCompleted (Ok newPerson) ->
            { model | person = newPerson } => Cmd.none

        FavoriteCompleted (Err error) ->
            -- In a serious production application, we would log the error to
            -- a logging service so we could investigate later.
            [ "There was a server error trying to record your Favorite. Sorry!" ]
                |> Util.appendErrors model
                => Cmd.none

        ToggleFollow ->
            let
                cmdFromAuth authToken =
                    authToken
                        |> Request.Profile.toggleFollow author.username author.following
                        |> Http.send FollowCompleted
            in
            session
                |> Session.attempt "follow" cmdFromAuth
                |> Tuple.mapFirst (Util.appendErrors model)

        FollowCompleted (Ok { following }) ->
            let
                newPerson =
                    { person | author = { author | following = following } }
            in
            { model | person = newPerson } => Cmd.none

        FollowCompleted (Err error) ->
            { model | errors = "Unable to follow user." :: model.errors }
                => Cmd.none

        SetCommentText commentText ->
            { model | commentText = commentText } => Cmd.none

        PostComment ->
            let
                comment =
                    model.commentText
            in
            if model.commentInFlight || String.isEmpty comment then
                model => Cmd.none
            else
                let
                    cmdFromAuth authToken =
                        authToken
                            |> Request.Person.Comments.post model.person.slug comment
                            |> Http.send CommentPosted
                in
                session
                    |> Session.attempt "post a comment" cmdFromAuth
                    |> Tuple.mapFirst (Util.appendErrors { model | commentInFlight = True })

        CommentPosted (Ok comment) ->
            { model
                | commentInFlight = False
                , comments = comment :: model.comments
            }
                => Cmd.none

        CommentPosted (Err error) ->
            { model | errors = model.errors ++ [ "Server error while trying to post comment." ] }
                => Cmd.none

        DeleteComment id ->
            let
                cmdFromAuth authToken =
                    authToken
                        |> Request.Person.Comments.delete model.person.slug id
                        |> Http.send (CommentDeleted id)
            in
            session
                |> Session.attempt "delete comments" cmdFromAuth
                |> Tuple.mapFirst (Util.appendErrors model)

        CommentDeleted id (Ok ()) ->
            { model | comments = withoutComment id model.comments }
                => Cmd.none

        CommentDeleted id (Err error) ->
            { model | errors = model.errors ++ [ "Server error while trying to delete comment." ] }
                => Cmd.none

        DeletePerson ->
            let
                cmdFromAuth authToken =
                    authToken
                        |> Request.Person.delete model.person.slug
                        |> Http.send PersonDeleted
            in
            session
                |> Session.attempt "delete persons" cmdFromAuth
                |> Tuple.mapFirst (Util.appendErrors model)

        PersonDeleted (Ok ()) ->
            model => Route.modifyUrl Route.Home

        PersonDeleted (Err error) ->
            { model | errors = model.errors ++ [ "Server error while trying to delete person." ] }
                => Cmd.none



-- INTERNAL --


withoutComment : CommentId -> List Comment -> List Comment
withoutComment id =
    List.filter (\comment -> comment.id /= id)


favoriteButton : Person a -> Html Msg
favoriteButton person =
    let
        favoriteText =
            " Favorite Person (" ++ toString person.favoritesCount ++ ")"
    in
    Favorite.button (\_ -> ToggleFavorite) person [] [ text favoriteText ]


deleteButton : Person a -> Html Msg
deleteButton person =
    button [ class "btn btn-outline-danger btn-sm", onClick DeletePerson ]
        [ i [ class "ion-trash-a" ] [], text " Delete Person" ]


editButton : Person a -> Html Msg
editButton person =
    a [ class "btn btn-outline-secondary btn-sm", Route.href (Route.EditPerson person.slug) ]
        [ i [ class "ion-edit" ] [], text " Edit Person" ]


followButton : Follow.State record -> Html Msg
followButton =
    Follow.button (\_ -> ToggleFollow)
