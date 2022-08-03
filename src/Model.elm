module Model exposing (Model, Msg(..), values)

type alias Model =
    {
        board: List String,
        currentPlayer: Int
    }

values : List String
values =
    [ "", "O", "X" ]

type Msg --update message types
    = MarkSquare Int
    | DoNothing