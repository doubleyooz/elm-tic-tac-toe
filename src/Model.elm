module Model exposing (Data, GameMode(..), GameState(..), Model, Msg(..), Player(..), RequestBody, fillSquare)

import Http


type alias Model =
    { board : List (Maybe Player)
    , currentPlayer : Player
    , selectedPlayer : Player
    , gameState : GameState
    , gameMode : GameMode
    , errMsg : Maybe String
    , crossesWon : Int
    , noughtsWon : Int
    , dropMenu : Bool
    }


type GameState
    = Draw
    | Win
    | OnGoing
    | Beginning


type GameMode
    = Easy
    | Medium
    | Hard
    | Impossible
    | Friend


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
    | BestMove (Result Http.Error Data)
    | DropMenu Bool
    | DoNothing
    | SelectPlayer Player
    | ChangeMode GameMode
    | Reset
