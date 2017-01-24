module Types exposing (..)

-- MODEL
type alias Model =
  { message : String
  , messages : List Message
  , room : String
  , rooms : List String
  , user : String
  , users : List String
  }

type alias Message =
  { user : String
  , message : String
  , timestamp : Int
  }

-- MESSAGES
type Msg = None
  | Clear
  | Exit
  | InputMessage String
  | InputUser String
  | Select String -- Select <room>
  | SignIn String String -- SignIn <user> <room>
  | SignOut
  | SendChatMessage Message String -- Send <message> <room>
  | SendSocketMessage String
  | ReceiveChatMessage Message -- Receive <message>
  | ReceiveSocketMessage String
  | UserIn String -- UserIn <user>
  | UserOut String -- UserOut <user>
