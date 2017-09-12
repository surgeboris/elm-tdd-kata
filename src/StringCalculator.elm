module StringCalculator exposing (add)

import Regex

add : String -> Int
add input =
  if String.isEmpty input then 0
  else splitInput >> parseNumbers >> List.sum <| input

splitInput : String -> List String
splitInput =
  let
    delimiter = Regex.regex ",|\\n"
  in
    Regex.split Regex.All delimiter

parseNumbers : List String -> List Int
parseNumbers = List.map <| Result.withDefault 0 << String.toInt
