module Utils exposing (getElementByIndex, getLast)


getLast : List a -> Maybe a
getLast list =
    List.head (List.reverse list)


getElementByIndex : List a -> Int -> Maybe a
getElementByIndex list i =
    case i of
        0 ->
            List.head list

        _ ->
            getElementByIndex
                (case List.tail list of
                    Just t ->
                        t

                    Nothing ->
                        []
                )
                (i - 1)
