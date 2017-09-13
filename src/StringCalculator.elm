module StringCalculator exposing (add)

import Regex

type alias AdditionError = String

add : String -> Result AdditionError Int
add input =
  if String.isEmpty input then Ok 0
  else splitInput input
    |> Result.andThen parseNumbers
    |> Result.map List.sum

splitInput : String -> Result AdditionError (List String)
splitInput input =
  let
    delimiter = Regex.regex ",|\\n"
    splitList = Regex.split Regex.All delimiter input
    filterEmptyStrings = List.filter <| not << String.isEmpty
    lastSplitItem = (List.head << List.reverse) splitList
  in
    case lastSplitItem of
      Just item ->
        if String.isEmpty item
          then Err "Wrong input: superfluous delimiter at the end"
        else Ok <| filterEmptyStrings splitList
      Nothing -> Err "Program error: splitInput cannot get last split item!"

appendItemIntoList : a -> List a -> List a
appendItemIntoList item list = list ++ [item]

parseNumbers : List String -> Result AdditionError (List Int)
parseNumbers list =
  let
    results = List.map String.toInt list
    foldResults = Result.map2 appendItemIntoList
    folded = List.foldl foldResults (Ok []) results
    customizeErrMsg = Result.mapError
      <| always "Invalid input: one of numbers cannot be parsed"
  in
    customizeErrMsg folded
