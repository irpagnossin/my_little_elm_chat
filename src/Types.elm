module Types exposing (..)

-- APP MODEL


type alias Model =
    { connected : Bool
    , message : String
    , messages : List SocketMessage
    , room : String
    , rooms : List String
    , screen : Screen
    , server : String
    , user : String
    , users : List String
    }



-- MESSAGES


type alias SocketMessage =
    { action : String
    , message : String
    , room : String
    , user : String
    }


type Msg
    = None
    | Clear
    | Exit
    | InputMessage String
    | InputUser String
    | SelectRoom String
    | SetUsers (List String)
    | SignIn String String
    | SendChatMessage String
    | ReceiveChatMessage SocketMessage
    | UserIn String
    | UserOut String



-- PAGES


type Screen
    = ChatScreen
    | LoginScreen
