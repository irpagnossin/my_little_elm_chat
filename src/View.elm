module View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (..)
import Types exposing (..)
import LoginPage exposing (loginView)
import ChatPage exposing (chatView)


root : Model -> Html Msg
root model =
    div
        [ class "chat" ]
        [ header
            [ class "navbar" ]
            [ h1 [] [ text "My little Elm chat client" ] ]
        , inner model
        , footer
            []
            [ p
                []
                [ a
                    [ href "https://creativecommons.org/licenses/by/4.0/legalcode" ]
                    [ text "CC BY 4.0" ]
                , text " irpagnossin 2017"
                ]
            ]
        ]


inner : Model -> Html Msg
inner model =
    case model.screen of
        LoginScreen ->
            loginView model

        ChatScreen ->
            chatView model
