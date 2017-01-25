module Socket exposing (receive_message, send_message, sign_in, sign_out)

import Types exposing (..)
import WebSocket

receive_message : String -> Msg
receive_message message =
  ReceiveChatMessage {user = "bla", message = message, timestamp = 1}
  -- TODO PROCESSAMENTO DE MENSAGEM VEM AQUI

send_message : String -> String -> String -> String -> Cmd Msg
send_message server user room message =
  WebSocket.send server ("MESSAGE/" ++ user ++ "/" ++ room ++ "/" ++ message)

sign_in : String -> String -> String -> Cmd Msg
sign_in server user room =
  WebSocket.send server ("SIGN-IN/" ++ user ++ "/" ++ room)

sign_out : String -> String -> Cmd Msg
sign_out server user =
  WebSocket.send server ("SIGN-OUT/" ++ user)
