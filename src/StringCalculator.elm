module StringCalculator exposing (add)

add : String -> Int
add input =
  if String.isEmpty input then 0
  else splitInput >> parseNumbers >> List.sum <| input

splitInput : String -> List String
splitInput = String.split ","

parseNumbers : List String -> List Int
parseNumbers = List.map <| Result.withDefault 0 << String.toInt
