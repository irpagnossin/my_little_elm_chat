module Types exposing (..)

-- MODEL
type alias Model =
  { message : String
  , messages : List Message
  , room : String
  , rooms : List String
  , screen : Screen
  , server : String
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
  | SelectRoom String -- Select <room>
  | SignIn String String -- SignIn <user> <room>
  | SignOut
  | SendChatMessage Message -- Send <message> <room>
  | ReceiveChatMessage Message -- Receive <message>
  | UserIn String -- UserIn <username>
  | UserOut String -- UserOut <username>

type Screen
  = ChatScreen
  | LoginScreen
