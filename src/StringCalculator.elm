module StringCalculator exposing (add)

import Regex

type alias AdditionError = String

add : String -> Result AdditionError Int
add input =
  if String.isEmpty input then Ok 0
  else splitInput input
    |> Result.andThen parseNumbers
    |> Result.andThen validateNumbers
    |> Result.map ignoreTooBig
    |> Result.map List.sum

splitInput : String -> Result AdditionError (List String)
splitInput input =
  let
    { delimiter, strippedInput } = getParamsForSplitInput input
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

type alias ParamsForSplitInput = {
  delimiter : Regex.Regex,
  strippedInput : String
}
getParamsForSplitInput : String -> ParamsForSplitInput
getParamsForSplitInput input =
  let
    customDelimiter = Regex.regex "^//(.+)\\n"
    defaultInputParams = {
      delimiter = Regex.regex ",|\\n",
      strippedInput = input
    }
    pickCustomDelimiter =
      Regex.find (Regex.AtMost 1) customDelimiter
      >> List.map .submatches >> List.concat
      >> List.head >> Maybe.withDefault Nothing
      >> Maybe.andThen parseCustomDelimiter
    stripInput =
      Regex.replace (Regex.AtMost 1) customDelimiter <| always ""
  in
    case pickCustomDelimiter input of
      Nothing -> defaultInputParams
      Just delimiter -> {
        delimiter = delimiter,
        strippedInput = stripInput input
      }

parseCustomDelimiter : String -> Maybe Regex.Regex
parseCustomDelimiter delimiterInput =
  let
    isSingleCharDelimiter = String.length delimiterInput == 1
    multicharDelimiterRegex = Regex.regex "\\[([^[\\]]*)\\]"
    sortByStringLengthDesc = \a b -> compare (String.length b) (String.length a)
    getMulticharDelimiterList =
      Regex.find Regex.All multicharDelimiterRegex
      >> List.map .submatches >> List.concat
      >> List.foldl (Maybe.map2 appendItemIntoList) (Just [])
      >> Maybe.map (List.sortWith sortByStringLengthDesc)
    getDelimiterRegex = List.map Regex.escape >> String.join "|" >> Regex.regex
  in
    if isSingleCharDelimiter
      then Just <| getDelimiterRegex [delimiterInput]
    else
      Maybe.map getDelimiterRegex <| getMulticharDelimiterList delimiterInput

appendItemIntoList : a -> List a -> List a
appendItemIntoList item list = list ++ [item]

validateNumbers : List Int -> Result AdditionError (List Int)
validateNumbers list =
  let
    negatives = list |>
      List.filter (0 |> (>)) >> List.map toString >> String.join ","
 in
    if String.isEmpty negatives then Ok list
    else Err <| "Invalid input: negatives found - " ++ negatives

ignoreTooBig : List Int -> List Int
ignoreTooBig = List.map <| \item -> if item > 1000 then 0 else item

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
