module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (GameState(..), Model, Msg(..), Player(..), fillSquare)
import Update exposing (update)
import Utils exposing (getElementByIndex, getLast)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( { board = [ Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing ]
      , currentPlayer = Player1
      , gameState = OnGoing
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
    case model.gameState of
        OnGoing ->
            div [ class "game-container" ]
                [ div [ class "board" ]
                    (List.indexedMap
                        (\i x ->
                            div
                                [ class
                                    ("square"
                                        ++ (case i of
                                                1 ->
                                                    " inline-border"

                                                3 ->
                                                    " block-border"

                                                4 ->
                                                    " full-border"

                                                5 ->
                                                    " block-border"

                                                7 ->
                                                    " inline-border"

                                                _ ->
                                                    ""
                                           )
                                    )
                                , onClick (MarkSquare i)
                                ]
                                [ text (fillSquare x) ]
                        )
                        model.board
                    )
                ]

        Draw ->
            Debug.todo "branch 'Draw' not implemented"

        Win ->
            Debug.todo "branch 'Win' not implemented"
