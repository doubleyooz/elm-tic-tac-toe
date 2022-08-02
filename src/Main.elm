module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Msg)
import Update exposing (update)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


values : List Int
values =
    [ 0, 1, 2 ]



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( { board = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
      }
    , Cmd.none
    )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []



-- view


view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ div [ class "board" ]
            [ div [ class "square" ] [ text "X" ]
            , div
                [ class "square inline-border" ]
                [ text "X" ]
            , div [ class "square" ] [ text "X" ]
            , div [ class "square block-border" ] [ text "X" ]
            , div
                [ class "square full-border" ]
                [ text "X" ]
            , div [ class "square block-border" ] [ text "X" ]
            , div [ class "square" ] [ text "X" ]
            , div
                [ class "square inline-border" ]
                [ text "X" ]
            , div [ class "square" ] [ text "X" ]
            ]
        ]
