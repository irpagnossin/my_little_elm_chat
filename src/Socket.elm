module Socket
    exposing
        ( encodeSocketMessage
        , receive_message
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
            else
                ReceiveChatMessage msg

        -- TODO: processamento das mensagens
        Err error ->
            None
