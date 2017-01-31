module State exposing (init, subscriptions, update)

import Socket exposing (encodeSocketMessage, receive_message, sign_out)
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
        None ->
            model ! []

        Clear ->
            { model | message = "" } ! []

        Exit ->
            let
                username =
                    model.user
            in
                (init model.server)
                    ! [ sign_out model.server username ]

        InputMessage msg ->
            { model | message = msg } ! []

        InputUser usr ->
            { model | user = usr } ! []

        ReceiveChatMessage message ->
            { model | messages = message :: model.messages } ! []

        SelectRoom room ->
            { model | room = room } ! []

        SendChatMessage message ->
            let
              socket_message = encodeSocketMessage
                <| SocketMessage "USER_SAYS" message model.room model.user
            in
              { model | message = "" }
                ! [ WebSocket.send model.server socket_message ]


        SignIn user room ->
            if (user == "") || (room == "") then
                model ! []
            else
              let
                socket_message =
                  encodeSocketMessage <| SocketMessage "SIGN-IN" "" model.room model.user
              in
                { model | room = room, user = user, screen = ChatScreen, users = user :: model.users }
                  ! [ send model.server socket_message ]

        -- User has asked to leave
        SignOut ->
          let
            socket_message =
              encodeSocketMessage <| SocketMessage "SIGN_OUT" "" model.room model.user
          in
            init model.server ! [ send model.server socket_message ]

        -- A new user has arrived
        UserIn username ->
          let
            socket_message =
              SocketMessage "" "cheguei! :D" model.room username
          in
            { model
            | users = username :: model.users
            , messages = socket_message :: model.messages
            } ! []

        -- A user has left
        UserOut username ->
          { model
          | users = List.filter ((/=) username) model.users
          } ! []



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    listen model.server receive_message
