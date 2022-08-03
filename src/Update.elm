module Update exposing (update)

import Model exposing (Model, Msg(..), values)
import Utils exposing (getElementByIndex, getLast)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        MarkSquare id ->
            ( { model
                | board =
                    List.indexedMap
                        (\i x ->
                            if i == id then
                                case getElementByIndex values model.currentPlayer of
                                    Just value ->
                                        value

                                    Nothing ->
                                        x

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
