module Model exposing (Model, Msg(..), Square(..), fillSquare)

type alias Model =
    {
        board: List Square,
        currentPlayer: Int
    }

type Square 
    = Empty
    | Player1
    | Player2

fillSquare : Square -> String
fillSquare squareType = 
    case squareType of
        Empty -> ""
        Player1 -> "X"
        Player2 -> "O"
    
type Msg --update message types
    = MarkSquare Int
    | DoNothing