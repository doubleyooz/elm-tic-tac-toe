module Update exposing (update)

import Env exposing (bestMoveURL, finalStateURL)
import Http
import Json.Decode as Decode
    exposing
        ( Decoder
        , decodeString
        , field
        , int
        , list
        , map2
        , map3
        , string
        )
import Json.Encode as Encode
import Model exposing (Data, GameMode(..), GameState(..), Model, Msg(..), Player(..), RequestBody, fillSquare)
import Utils exposing (getElementByIndex, getLast)


isEndStateRequest : List (Maybe Player) -> Cmd Msg
isEndStateRequest board =
    Http.post
        { url = finalStateURL
        , body = Http.jsonBody (endStateEncoder board)
        , expect = Http.expectJson IsEndState endStateDecoder
        }


bestMoveRequest : List (Maybe Player) -> Player -> Cmd Msg
bestMoveRequest board currentPlayer =
    Http.post
        { url = bestMoveURL
        , body = Http.jsonBody (bestMoveEncoder board currentPlayer)
        , expect = Http.expectJson BestMove bestMoveDecoder
        }


endStateEncoder : List (Maybe Player) -> Encode.Value
endStateEncoder board =
    Encode.object
        [ ( "board", Encode.list Encode.string (List.map fillSquare board) )
        , ( "values", Encode.list Encode.string [ "", "X", "O" ] )
        ]


bestMoveEncoder : List (Maybe Player) -> Player -> Encode.Value
bestMoveEncoder board currentPlayer =
    Encode.object
        [ ( "board", Encode.list Encode.string (List.map fillSquare board) )
        , ( "values"
          , Encode.list Encode.string
                (case currentPlayer of
                    Player1 ->
                        [ "", fillSquare (Just Player1), fillSquare (Just Player2) ]

                    _ ->
                        [ "", fillSquare (Just Player2), fillSquare (Just Player1) ]
                )
          )
        ]


bestMoveDecoder : Decoder Data
bestMoveDecoder =
    map2 Data
        (field "code" int)
        (field "data" int)


endStateDecoder : Decoder Data
endStateDecoder =
    map2 Data
        (field "code" int)
        (field "data" int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        IsEndState (Ok res) ->
            let
                nextPlayer =
                    case model.currentPlayer of
                        Player2 ->
                            Player1

                        Player1 ->
                            Player2
            in
            ( { model
                | gameState =
                    case res.data + 1 of
                        0 ->
                            model.gameState

                        1 ->
                            Draw

                        4 ->
                            OnGoing

                        _ ->
                            Win
                , currentPlayer =
                    nextPlayer
                , crossesWon =
                    case res.data + 1 of
                        2 ->
                            model.crossesWon + 1

                        _ ->
                            model.crossesWon
                , noughtsWon =
                    case res.data + 1 of
                        3 ->
                            model.noughtsWon + 1

                        _ ->
                            model.noughtsWon
                , errMsg = Just ""
              }
            , case res.data + 1 of
                4 ->
                    case model.gameMode of
                        Friend ->
                            Cmd.none

                        _ ->
                            {- Put call the engine logic here -}
                            bestMoveRequest model.board nextPlayer

                _ ->
                    Cmd.none
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
                            Just "Lost connection to the server"

                        Http.BadStatus _ ->
                            Just "BadStatus"
              }
            , Cmd.none
            )

        Reset ->
            ( { model
                | board = [ Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing ]
                , gameState = Beginning
                , currentPlayer = Player1
                , errMsg = Nothing
              }
            , Cmd.none
            )

        SelectPlayer player ->
            ( { model
                | currentPlayer = player
              }
            , Cmd.none
            )

        ChangeMode mode ->
            ( { model
                | gameMode = mode
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
                              }
                            , isEndStateRequest newBoard
                            )

                        _ ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        DropMenu state ->
            ( { model
                | dropMenu = state
              }
            , Cmd.none
            )

        BestMove (Ok res) ->
            case getElementByIndex model.board res.data of
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
                                                    if i == res.data then
                                                        Just model.currentPlayer

                                                    else
                                                        Nothing
                                        )
                                        model.board
                            in
                            ( { model
                                | board = newBoard
                              }
                            , isEndStateRequest newBoard
                            )

                        _ ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        BestMove (Err _) ->
            Debug.todo "branch 'BestMove (Err _)' not implemented"
