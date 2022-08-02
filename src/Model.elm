module Model exposing (Model, Msg)

type alias Model =
    {
        board: List Int
    }

type Msg --update message types
    = Roll
    | NewFace (List Int)
    | RollAnimation Int
    | SetTurn Int
    | DoNothing