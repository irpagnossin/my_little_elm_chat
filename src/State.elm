module State exposing (init, subscriptions, update)

import Socket
    exposing
        ( encodeSocketMessage
        , listen
        , receive_message
        , send_user_message
        , sign_in
        , sign_out
        , request_users
        )
import String exposing (isEmpty)
import Task
import Types exposing (..)


-- INITIAL STATE


init : String -> Model
init server =
    { connected = False
    , message = ""
    , messages = []
    , room = ""
    , rooms = [ "1", "2", "3" ]
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
                ! [ sign_out model.server model.room model.user ]

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

        -- User selected a chat room
        SelectRoom2 room ->
            { model | room = toString (room) } ! []

        -- User said something to everybody inside the chat room
        SendChatMessage message ->
            { model | message = "" }
                ! [ send_user_message model.server model.room model.user message ]

        -- Server informs all users connected to chat room
        SetUsers users ->
            { model | users = users } ! []

        -- User signs in
        SignIn user room ->
            if isEmpty user || isEmpty room then
                model ! []
            else
                { model
                    | connected = True
                    , room = room
                    , user = user
                    , screen = ChatScreen
                }
                    ! [ request_users model.server room user
                      , sign_in model.server room user
                      ]

        -- Server informs a new user has arrived
        UserIn username ->
            let
                socket_message =
                    SocketMessage "USER_SAYS" (username ++ " entrou na sala.") model.room ""
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
    if model.connected then
        listen model
    else
        Sub.none
