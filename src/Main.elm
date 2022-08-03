module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))
import Update exposing (update)
import Utils exposing (getElementByIndex, getLast)
import Model exposing (Square(..))
import Model exposing (fillSquare)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( { board = [ Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty ]
      , currentPlayer = 1 -- 1 or 2
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
