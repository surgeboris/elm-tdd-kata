module StringCalculatorTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)

import StringCalculator

suite : Test
suite =
  describe "StringCalculator"
    [ describe "\"add\" method"


      [ test "can be called with empty string" <|
        \_ -> Expect.equal (StringCalculator.add "") 0


      , test "can be called with string of one number" <|
        \_ -> Expect.equal (StringCalculator.add "123") 123


      , test "can be called with string of any amount of numbers" <|
        \_ ->
          let
            -- put any amount as n (haven't used fuzz or Random because of "JS heap out of memory error")
            n = 10
            input = String.join "," (List.repeat n "1")
          in
            Expect.equal (StringCalculator.add input) n


      , test "can use newlines as delimiters between numbers" <|
        \_ ->
          Expect.equal (StringCalculator.add "1\n2,3") 6


      ]]
