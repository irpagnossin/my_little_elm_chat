module Socket exposing (connect)

connect : String -> String -> String
connect user room =
  "CONNECT/" ++ user ++ "/" ++ room
