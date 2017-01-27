module State exposing (init, subscriptions, update)

import Socket exposing (receive_message, send_message, sign_in, sign_out)
import Task
import Types exposing (..)
import WebSocket


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
            { model | message = "" }
                ! [ send_message model.server model.user model.room message.message ]

        SignIn user room ->
            if (user == "") || (room == "") then
                model ! []
            else
                { model | room = room, user = user, screen = ChatScreen, users = user :: model.users }
                    ! [ sign_in model.server user room ]

        SignOut ->
            { message = ""
            , messages = []
            , room = ""
            , rooms = model.rooms
            , screen = LoginScreen
            , server = model.server
            , user = model.user
            , users = []
            }
                ! [ sign_out model.server model.user ]

        UserIn username ->
            let
                new_model =
                    { model | users = username :: model.users }

                new_message =
                    { user = "chat", message = username ++ " entrou na sala", timestamp = 1 }
            in
                new_model
                    ! [ Task.perform identity <| Task.succeed <| ReceiveChatMessage new_message ]

        UserOut username ->
            { model | users = List.filter ((/=) username) model.users }
                ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen model.server receive_message
