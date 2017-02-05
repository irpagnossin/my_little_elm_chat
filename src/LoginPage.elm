module LoginPage exposing (loginView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (..)
import Types exposing (..)
import Json.Decode as Json
import Html.Events.Extra exposing (onEnter, targetValueIntParse)


loginView : Model -> Html Msg
loginView model =
    section
        []
        [ div
            [ class "row"
            , onEnter <| SignIn model.user model.room
            ]
            [ div
                [ class "col-md-6 col-md-offset-3" ]
                [ p
                    []
                    [ text "Escolha a sala:" ]
                , select
                    [ class "col-md-3"
                    , onChange
                    ]
                    (viewOptions model.rooms)
                ]
            , div
                [ class "col-md-6 col-md-offset-3" ]
                [ p
                    []
                    [ text "Seu nome:" ]
                , input
                    [ onInput InputUser
                    , value model.user
                    , placeholder "Nome"
                    , class "col-md-3"
                    ]
                    []
                ]
            ]
        , div
            [ class "row" ]
            [ button
                [ onClick (SignIn model.user model.room), class (eligibleUser model) ]
                [ text "Sign-in" ]
            ]
        ]


viewOption : String -> Html Msg
viewOption opt =
    option [{- onClick (SelectRoom opt) -}] [ text opt ]


viewOptions : List String -> List (Html Msg)
viewOptions opts =
    option [] [] :: (List.map viewOption opts)


eligibleUser : Model -> String
eligibleUser model =
    if String.isEmpty model.user || String.isEmpty model.room then
        "btn btn-lg btn-default col-md-offset-3"
    else
        "btn btn-lg btn-primary col-md-offset-3"


onChange =
    on "change" (Json.map SelectRoom2 targetValueIntParse)
