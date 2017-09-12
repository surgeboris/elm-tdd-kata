module StringCalculator exposing (add)

import Regex

add : String -> Int
add input =
  if String.isEmpty input then 0
  else splitInput >> parseNumbers >> List.sum <| input

splitInput : String -> List String
splitInput = Regex.split Regex.All <| Regex.regex ",|\\n"

parseNumbers : List String -> List Int
parseNumbers = List.map <| Result.withDefault 0 << String.toInt
