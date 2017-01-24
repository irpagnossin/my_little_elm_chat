module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Socket exposing (..)
import State exposing (..)
import Types exposing (..)

root : Model -> Html Msg
root model =
  div []
    [ div [] (List.map viewMessage (List.map (.message) model.messages))
    , input [onInput InputUser] []
    , button [onClick (SendSocketMessage (connect model.user model.room))] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
