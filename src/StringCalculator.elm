module StringCalculator exposing (add)

add : String -> Int
add input =
  if String.isEmpty input then 0
  else String.toInt input |> Result.withDefault 0
