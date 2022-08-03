module Update exposing (update)

import Model exposing (Model, Msg(..), Square(..), fillSquare)
import Utils exposing (getElementByIndex, getLast)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        MarkSquare id ->
            case getElementByIndex model.board id of
                Just val ->
                    case val of
                        Empty ->
                            ( { model
                                | board =
                                    List.indexedMap
                                        (\i x ->
                                            if i == id then
                                                case model.currentPlayer of
                                                    1 ->
                                                        Player1

                                                    _ ->
                                                        Player2

                                            else
                                                x
                                        )
                                        model.board
                                , currentPlayer =
                                    case model.currentPlayer of
                                        2 ->
                                            1

                                        _ ->
                                            2
                              }
                            , Cmd.none
                            )

                        _ ->
                            update DoNothing model

                Nothing ->
                    update DoNothing model
