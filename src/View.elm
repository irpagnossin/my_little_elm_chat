module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    case model.screen of
        LoginScreen ->
            loginView model

        ChatScreen ->
            chatView model


loginView : Model -> Html Msg
loginView model =
    div []
        [ select [] (viewOptions model.rooms)
        , input [ onInput InputUser, value model.user ] []
        , button [ onClick (SignIn model.user model.room) ] [ text "Sign-in" ]
        ]


chatView : Model -> Html Msg
chatView model =
    div [ class "container" ]
        [ div []
            [ div [ class "users-area" ] [ viewUsers model ]
            , div [ class "messages-area" ] [ viewMessages model ]
            ]
        , div [ class "message-area" ]
            [ textarea [ onInput InputMessage, value model.message ] []
            , button [ onClick (SendChatMessage model.message) ] [ text "Send" ]
            ]
        , div [ class "control-area" ]
            [ button [ onClick Exit ] [ text "Exit" ]
            , button [ onClick Clear ] [ text "Clear" ]
            ]
        ]


viewUser : String -> Html msg
viewUser username =
    li [] [ text username ]


viewUsers : Model -> Html Msg
viewUsers model =
    ul [] <| List.map viewUser model.users


viewMessage : String -> Html msg
viewMessage msg =
    li [] [ text msg ]



-- TODO: remover segundo map


viewMessages : Model -> Html Msg
viewMessages model =
    ul [] <| List.map viewMessage <| List.map (.message) model.messages


viewOption : String -> Html Msg
viewOption opt =
    option [ onClick (SelectRoom opt) ] [ text opt ]


viewOptions : List String -> List (Html Msg)
viewOptions opts =
    option [] [] :: (List.map viewOption opts)
