module App exposing (main)

import Html
import State
import View


server : String
server =
    "ws://localhost:9001"


main =
    Html.program
        { init = State.init server ! []
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.root
        }
