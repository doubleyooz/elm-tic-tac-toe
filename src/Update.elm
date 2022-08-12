module Update exposing (update)

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
import Env exposing (client)


isEndStateRequest : Model -> Cmd Msg
isEndStateRequest model =
    Http.post
        { url = client
        , body = Http.jsonBody (requestEncoder model)
        , expect = Http.expectJson IsEndState requestDecoder
        }


requestEncoder : Model -> Encode.Value
requestEncoder model =
    Encode.object
        [ ( "board", Encode.list Encode.string (List.map fillSquare model.board) )
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

        SendIsEndStateRequest ->
            ( model, isEndStateRequest model )

        IsEndState (Ok ds) ->
            ( { model
                | gameState =
                    case ds.data + 1 of
                        0 ->
                            OnGoing

                        1 ->
                            Draw

                        _ ->
                            Win
              }
            , Cmd.none
            )

        IsEndState (Err _) ->
            ( model, Cmd.none )

        MarkSquare id ->
            case getElementByIndex model.board id of
                Just val ->
                    case val of
                        Nothing ->
                            ( { model
                                | board =
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
                                , currentPlayer =
                                    case model.currentPlayer of
                                        Player2 ->
                                            Player1

                                        Player1 ->
                                            Player2
                              }
                            , isEndStateRequest model
                            )

                        _ ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )
