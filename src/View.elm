module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (..)
import Types exposing (..)

root : Model -> Html Msg
root model =
  div []
    [ div [] (List.map viewMessage (List.map (.message) model.messages))
    , input [onInput InputMessage] []
    , button [onClick (SendSocket "CONNECT")] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
