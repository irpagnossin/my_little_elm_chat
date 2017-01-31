module Socket exposing
  ( encodeSocketMessage
  , receive_message
  , sign_out
  )

import Json.Decode exposing (decodeString, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode exposing (encode, object)
import Types exposing (..)
import WebSocket



-- Encode messages to send them to websocket server
encodeSocketMessage : SocketMessage -> String
encodeSocketMessage {action, message, room, user} =
  encode 0 <|
    object
      [ ("action", Json.Encode.string action)
      , ("message", Json.Encode.string message)
      , ("room", Json.Encode.string room)
      , ("user", Json.Encode.string user)
      ]


-- Decode messages from websocket server
socketMessageDecoder : Decoder SocketMessage
socketMessageDecoder =
  decode SocketMessage
    |> required "action" string
    |> required "message" string-- (nullable string)
    |> required "room" string-- (nullable string)
    |> required "user" string


receive_message : String -> Msg
receive_message message =
  case decodeString socketMessageDecoder message of
    Ok msg -> ReceiveChatMessage msg
      -- TODO: processamento das mensagens
    Err error -> None


sign_in : String -> String -> String -> Cmd Msg
sign_in server user room =
  WebSocket.send server ("SIGN-IN/" ++ user ++ "/" ++ room)

sign_out : String -> String -> Cmd Msg
sign_out server user =
  WebSocket.send server ("SIGN-OUT/" ++ user)
