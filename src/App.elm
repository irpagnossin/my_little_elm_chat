module App exposing (main)

import Html
import State
import View

main =
  Html.program
    { init = State.init
    , update = State.update
    , subscriptions = State.subscriptions
    , view = View.root
    }
