module Types exposing (..)

-- MODEL
type alias Model =
  { message : String
  , messages : List SocketMessage
  , room : String
  , rooms : List String
  , screen : Screen
  , server : String
  , user : String
  , users : List String
  }

type alias SocketMessage =
  { action : String
  , message : String
  , room : String
  , user : String
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
  | SendChatMessage String -- Send <message> <room>
  | ReceiveChatMessage SocketMessage -- Receive <message>
  | UserIn String -- UserIn <username>
  | UserOut String -- UserOut <username>

type Screen
  = ChatScreen
  | LoginScreen
