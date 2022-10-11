module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (GameMode(..), GameState(..), Model, Msg(..), Player(..), fillSquare)
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
      , gameState = Beginning
      , gameMode = Easy
      , errMsg = Nothing
      , crossesWon = 0
      , noughtsWon = 0
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
        [ div [ class "wrapper" ]
            [ div [ class "header" ]
                [ div [ class "difficulty" ] []
                , div [ class "score" ]
                    [ div
                        [ class
                            ("label"
                                ++ (case model.currentPlayer of
                                        Player1 ->
                                            " selected"

                                        _ ->
                                            ""
                                   )
                            )
                        , onClick
                            (case model.gameState of
                                Beginning ->
                                    SelectPlayer Player1

                                _ ->
                                    DoNothing
                            )
                        ]
                        [ text "X"
                        , case model.crossesWon of
                            0 ->
                                span [] [ text "-" ]

                            _ ->
                                span [] [ text (String.fromInt model.crossesWon) ]
                        ]
                    , div
                        [ class
                            ("label"
                                ++ (case model.currentPlayer of
                                        Player2 ->
                                            " selected"

                                        _ ->
                                            ""
                                   )
                            )
                        , onClick
                            (case model.gameState of
                                Beginning ->
                                    SelectPlayer Player2

                                _ ->
                                    DoNothing
                            )
                        ]
                        [ text "O"
                        , case model.noughtsWon of
                            0 ->
                                span [] [ text "-" ]

                            _ ->
                                span [] [ text (String.fromInt model.noughtsWon) ]
                        ]
                    ]
                , div [ class "turn" ]
                    [ text
                        (case model.gameState of
                            OnGoing ->
                                fillSquare (Just model.currentPlayer) ++ " Turn"

                            Beginning ->
                                fillSquare (Just model.currentPlayer) ++ " Turn"

                            _ ->
                                "Gameover"
                        )
                    ]
                ]
            , case model.gameState of
                Draw ->
                    div [ class "endgame", onClick Reset ] [ span [] [ text "Draw" ] ]

                Win ->
                    div [ class "endgame", onClick Reset ]
                        [ span []
                            [ text
                                (fillSquare
                                    (case model.currentPlayer of
                                        Player1 ->
                                            Just Player2

                                        Player2 ->
                                            Just Player1
                                    )
                                    ++ " Won"
                                )
                            ]
                        ]

                _ ->
                    div [ class "hide" ] []
            , div
                [ class
                    ("board"
                        ++ (case model.gameState of
                                OnGoing ->
                                    ""

                                Beginning ->
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

                                Beginning ->
                                    onClick (MarkSquare i)

                                _ ->
                                    onClick DoNothing
                            ]
                            [ text (fillSquare x) ]
                    )
                    model.board
                )
            , div [ class "reset" ] [ span [ onClick Reset ] [ text "Restart game" ] ]
            ]
        ]
