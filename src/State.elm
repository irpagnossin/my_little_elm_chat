module State exposing (init, subscriptions, update)

import Socket exposing (encodeSocketMessage, receive_message)
import String exposing (isEmpty)
import Task
import Types exposing (..)
import WebSocket exposing (listen, send)


-- INITIAL STATE


init : String -> Model
init server =
    { message = ""
    , messages = []
    , room = ""
    , rooms = [ "Sala 1", "Sala 2", "Sala 3" ]
    , screen = LoginScreen
    , server = server
    , user = ""
    , users = []
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Nothing to do
        None ->
            model ! []

        -- User cleared his message
        Clear ->
            { model | message = "" } ! []

        -- User exited the chat room
        Exit ->
            init model.server
                ! [ SocketMessage "SIGN_OUT" "" model.room model.user
                        |> encodeSocketMessage
                        |> send model.server
                  ]

        -- User inputs message
        InputMessage msg ->
            { model | message = msg } ! []

        -- User inputs username
        InputUser usr ->
            { model | user = usr } ! []

        -- Server informs a new message was sent
        ReceiveChatMessage message ->
            { model | messages = message :: model.messages } ! []

        -- User selected a chat room
        SelectRoom room ->
            { model | room = room } ! []

        -- User said something to everybody inside the chat room
        SendChatMessage message ->
            { model | message = "" }
                ! [ SocketMessage "USER_SAYS" message model.room model.user
                        |> encodeSocketMessage
                        |> send model.server
                  ]

        -- User signs in
        SignIn user room ->
            if isEmpty user || isEmpty room then
                model ! []
            else
                { model
                    | room = room
                    , user = user
                    , screen = ChatScreen
                }
                    ! [ SocketMessage "SIGN_IN" "" model.room model.user
                            |> encodeSocketMessage
                            |> send model.server
                      , SocketMessage "REQUEST_USERS" "" model.room model.user
                            |> encodeSocketMessage
                            |> send model.server
                      ]

        -- Server informs a new user has arrived
        UserIn username ->
            let
                socket_message =
                    SocketMessage "" "cheguei! :D" model.room username
            in
                { model
                    | users = username :: model.users
                    , messages = socket_message :: model.messages
                }
                    ! []

        -- Server informs a user has left
        UserOut username ->
            { model
                | users = List.filter ((/=) username) model.users
            }
                ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    listen model.server receive_message
