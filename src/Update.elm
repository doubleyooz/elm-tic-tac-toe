module Update exposing (update)

import Env exposing (client)
import Http
import Json.Decode as Decode
    exposing
        ( Decoder
        , decodeString
        , field
        , int
        , list
        , map2
        , string
        )
import Json.Encode as Encode
import Model exposing (Data, GameState(..), Model, Msg(..), Player(..), RequestBody, fillSquare)
import Utils exposing (getElementByIndex, getLast)


isEndStateRequest : List (Maybe Player) -> Cmd Msg
isEndStateRequest board =
    Http.post
        { url = client
        , body = Http.jsonBody (requestEncoder board)
        , expect = Http.expectJson IsEndState requestDecoder
        }


requestEncoder : List (Maybe Player) -> Encode.Value
requestEncoder board =
    Encode.object
        [ ( "board", Encode.list Encode.string (List.map fillSquare board) )
        , ( "values", Encode.list Encode.string [ "", "X", "O" ] )
        ]


requestDecoder : Decoder Data
requestDecoder =
    map2 Data
        (field "code" int)
        (field "data" int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        IsEndState (Ok ds) ->
            ( { model
                | gameState =
                    case ds.data + 1 of
                        0 ->
                            model.gameState

                        1 ->
                            Draw

                        4 ->
                            OnGoing

                        _ ->
                            Win
                , crossesWon =
                    case ds.data + 1 of
                        2 ->
                            model.crossesWon + 1

                        _ ->
                            model.crossesWon
                , noughtsWon =
                    case ds.data + 1 of
                        3 ->
                            model.noughtsWon + 1

                        _ ->
                            model.noughtsWon
                , errMsg = Just ""
              }
            , Cmd.none
            )

        IsEndState (Err x) ->
            ( { model
                | errMsg =
                    case x of
                        Http.BadBody _ ->
                            Just "BadBody"

                        Http.BadUrl _ ->
                            Just "BadUrl"

                        Http.Timeout ->
                            Just "Timeout"

                        Http.NetworkError ->
                            Just "NetworkErrored"

                        Http.BadStatus _ ->
                            Just "BadStatus"
              }
            , Cmd.none
            )

        MarkSquare id ->
            case getElementByIndex model.board id of
                Just val ->
                    case val of
                        Nothing ->
                            let
                                newBoard =
                                    List.indexedMap
                                        (\i x ->
                                            case x of
                                                Just player ->
                                                    Just player

                                                Nothing ->
                                                    if i == id then
                                                        Just model.currentPlayer

                                                    else
                                                        Nothing
                                        )
                                        model.board
                            in
                            ( { model
                                | board = newBoard
                                , currentPlayer =
                                    case model.currentPlayer of
                                        Player2 ->
                                            Player1

                                        Player1 ->
                                            Player2
                              }
                            , isEndStateRequest newBoard
                            )

                        _ ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )
