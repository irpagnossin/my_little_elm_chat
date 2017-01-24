module State exposing (init, subscriptions, update)

import Types exposing (..)
import WebSocket

-- INITIAL STATE
init : (Model, Cmd Msg)
init =
  { message = ""
  , messages = []
  , room = ""
  , rooms = ["Sala 1"]
  , user = ""
  , users = []
  } ! []

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    None ->
      model ! []

    Clear ->
      {model | message = ""} ! []

    Exit ->
      model ! []

    InputMessage msg ->
      {model | message = msg} ! []

    InputUser usr ->
      {model | user = usr} ! []

    ReceiveChatMessage message ->
      {model | messages = message :: model.messages} ! []

    ReceiveSocketMessage message ->
      model ! []

    Select room ->
      {model | room = room} ! []

    SendChatMessage message room ->
      {model | messages = message :: model.messages} ! []

    SendSocketMessage sock_message ->
      model ! [WebSocket.send "ws://echo.websocket.org" "SOCKET-SEND"]

    SignIn user room ->
      {model | user = user, room = room}
        ! [WebSocket.send "ws://echo.websocket.org" "CONNECT"]
        (modelo, comando)

    SignOut ->
      { message = ""
      , messages = []
      , room = ""
      , rooms = model.rooms
      , user = model.user
      , users = []
      } ! [WebSocket.send "ws://echo.websocket.org" "SIGN-OUT"]

    UserIn username ->
      {model | users = username :: model.users} ! []

    UserOut username ->
      {model | users = List.filter ((/=) username) model.users} ! []


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://echo.websocket.org" ReceiveSocket
