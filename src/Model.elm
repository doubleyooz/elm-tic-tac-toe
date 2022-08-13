module Model exposing (Data, GameState(..), Model, Msg(..), Player(..), RequestBody, fillSquare)

import Http


type alias Model =
    { board : List (Maybe Player)
    , currentPlayer : Player
    , gameState : GameState
    }


type GameState
    = Draw
    | Win
    | OnGoing


type Player
    = Player1
    | Player2


fillSquare : Maybe Player -> String
fillSquare squareType =
    case squareType of
        Just player ->
            case player of
                Player1 ->
                    "X"

                Player2 ->
                    "O"

        Nothing ->
            ""


type alias Data =
    { code : Int
    , data : Int
    }


type alias RequestBody =
    { values : List (Maybe Player)
    , board : List (Maybe Player)
    }


type
    Msg
    --update message types
    = MarkSquare Int
    | IsEndState (Result Http.Error Data)
    | DoNothing
