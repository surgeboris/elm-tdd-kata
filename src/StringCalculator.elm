module StringCalculator exposing (add)

add : String -> Int
add input =
  if String.isEmpty input then 0
  else String.split "," input
    |> List.map String.toInt
    |> List.map (Result.withDefault 0)
    |> List.sum
