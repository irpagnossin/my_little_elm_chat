module Socket
    exposing
        ( encodeSocketMessage
        , listen
        , receive_message
        , send_user_message
        , sign_in
        , sign_out
        , request_users
        )

import Json.Decode exposing (decodeString, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode exposing (encode, object)
import Types exposing (..)
import WebSocket


-- Encode messages to send them to websocket server


encodeSocketMessage : SocketMessage -> String
encodeSocketMessage { action, message, room, user } =
    encode 0 <|
        object
            [ ( "action", Json.Encode.string action )
            , ( "message", Json.Encode.string message )
            , ( "room", Json.Encode.string room )
            , ( "user", Json.Encode.string user )
            ]


listen : Model -> Sub Msg
listen model =
    WebSocket.listen model.server receive_message



-- Decode messages from websocket server


socketMessageDecoder : Decoder SocketMessage
socketMessageDecoder =
    decode SocketMessage
        {- TODO: union type -} |> required "action" string
        |> required "message" string
        |> required "room" string
        |> required "user" string


receive_message : String -> Msg
receive_message message =
    case decodeString socketMessageDecoder message of
        Ok msg ->
            if msg.action == "USER_IN" then
                UserIn msg.user
            else if msg.action == "ALL_USERS" then
                SetUsers <| String.split "," msg.message
            else if msg.action == "USER_OUT" then
                UserOut msg.user
            else
                ReceiveChatMessage msg

        -- TODO: processamento das mensagens
        Err error ->
            None


request_users : String -> String -> String -> Cmd Msg
request_users server room user =
    SocketMessage "REQUEST_USERS" "" room user
        |> encodeSocketMessage
        |> WebSocket.send server


send_user_message : String -> String -> String -> String -> Cmd Msg
send_user_message server room user message =
    SocketMessage "USER_SAYS" message room user
        |> encodeSocketMessage
        |> WebSocket.send server


sign_in : String -> String -> String -> Cmd Msg
sign_in server room user =
    SocketMessage "SIGN_IN" "" room user
        |> encodeSocketMessage
        |> WebSocket.send server


sign_out : String -> String -> String -> Cmd Msg
sign_out server room user =
    SocketMessage "SIGN_OUT" "" room user
        |> encodeSocketMessage
        |> WebSocket.send server
