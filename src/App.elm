module App exposing (main)

import Html
import State
import View

main =
  Html.program
    { init = State.init "ws://echo.websocket.org" ! []
    , update = State.update
    , subscriptions = State.subscriptions
    , view = View.root
    }
