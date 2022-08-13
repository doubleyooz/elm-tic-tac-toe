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
    div [ class "game-container" ]
        [ div [ class "turn" ]
            [ text
                (case model.gameState of
                    OnGoing ->
                        fillSquare (Just model.currentPlayer) ++ " Turn"

                    Draw ->
                        "Draw"

                    Win ->
                        fillSquare
                            (case model.currentPlayer of
                                Player1 ->
                                    Just Player2

                                Player2 ->
                                    Just Player1
                            )
                            ++ " Won"
                )
            ]
        , div [class ""] []
        , div
            [ class
                ("board"
                    ++ (case model.gameState of
                            OnGoing ->
                                ""

                            _ ->
                                " fade-out"
                       )
                )
            ]
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
                        , case model.gameState of
                            OnGoing ->
                                onClick (MarkSquare i)

                            _ ->
                                onClick DoNothing
                        ]
                        [ text (fillSquare x) ]
                )
                model.board
            )
        ]
