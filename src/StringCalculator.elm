module StringCalculator exposing (add)

import Regex

add : String -> Result String Int
add input =
  if String.isEmpty input then Ok 0
  else Result.map (parseNumbers >> List.sum) <| splitInput input

splitInput : String -> Result String (List String)
splitInput input =
  let
    delimiter = Regex.regex ",|\\n"
    splitList = Regex.split Regex.All delimiter input
    lastSplitItem = (List.head << List.reverse) splitList
  in
    case lastSplitItem of
      Just item ->
        if String.isEmpty item
          then Err "Wrong input: superfluous delimiter at the end"
        else Ok splitList
      Nothing -> Err "Program error: splitInput cannot get last split item!"

parseNumbers : List String -> List Int
parseNumbers = List.map <| Result.withDefault 0 << String.toInt
