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
      ]]
