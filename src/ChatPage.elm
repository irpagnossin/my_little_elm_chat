module ChatPage exposing (chatView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (..)
import Types exposing (..)


chatView : Model -> Html Msg
chatView model =
    section
        [ class "container" ]
        [ div
            []
            [ div
                [ class "users col-md-2" ]
                [ viewUsers model ]
            , div
                [ id "messages", class "col-md-10", rows 10 ]
                [ viewMessages model ]
            ]
        , div
            [ class "col-md-12" ]
            [ textarea
                [ onInput InputMessage, value model.message, class "message col-md-9", rows 3 ]
                []
            , button
                [ onClick (SendChatMessage model.message), class "btn btn-lg btn-primary col-md-2 col-md-offset-1" ]
                [ text "Send" ]
            ]
        , div
            [ class "col-md-12" ]
            [ button
                [ onClick Exit, class "btn btn-default" ]
                [ text "Exit" ]
            , button
                [ onClick Clear, class "btn btn-default" ]
                [ text "Clear" ]
            ]
        ]


viewUser : String -> String -> Html msg
viewUser current_user username =
    if current_user == username then
        li
            []
            [ text (username ++ "(você)") ]
    else
        li
            []
            [ text username ]


viewUsers : Model -> Html Msg
viewUsers model =
    ul [] <| List.map (viewUser model.user) model.users


viewMessages : Model -> Html Msg
viewMessages model =
    ul [] <| List.map (format_message model.user) model.messages


format_message : String -> SocketMessage -> Html Msg
format_message current_user { action, message, room, user } =
    if String.isEmpty user then
        li [] [ text message ]
    else if current_user == user then
        li [ style [ ( "color", "green" ) ] ]
            [ b [] [ text (user ++ " disse: ") ]
            , text message
            ]
    else
        li []
            [ b [] [ text (user ++ " disse: ") ]
            , text message
            ]
