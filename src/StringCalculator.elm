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
    { delimiter, strippedInput } = getDelimiter input
    splitList = Regex.split Regex.All delimiter strippedInput
    filterEmptyStrings = List.filter <| not << String.isEmpty
    lastSplitItem = (List.head << List.reverse) splitList
  in
    case lastSplitItem of
      Just item ->
        if String.isEmpty item
          then Err "Wrong input: superfluous delimiter at the end"
        else Ok <| filterEmptyStrings splitList
      Nothing -> Err "Program error: splitInput cannot get last split item!"

type alias DelimiterData = {
  delimiter : Regex.Regex,
  strippedInput : String
}
getDelimiter : String -> DelimiterData
getDelimiter input =
  let
    customDelimiter = Regex.regex "^//(.{1})\\n"
    defaultDelimiter = Regex.regex ",|\\n"
    pickCustomDelimiter =
      Regex.find (Regex.AtMost 1) customDelimiter
      >> List.map .submatches >> List.concat
      >> List.head >> Maybe.withDefault Nothing
    stripInput =
      Regex.replace (Regex.AtMost 1) customDelimiter <| always ""
  in
    case pickCustomDelimiter input of
      Nothing -> {
        delimiter = defaultDelimiter,
        strippedInput = input
      }
      Just r -> {
        delimiter = Regex.regex <| Regex.escape r,
        strippedInput = stripInput input
      }

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
