{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import Language.Haskell.TH (Quote)
import Language.Haskell.TH.Syntax (Exp)

Strictness

data Vec where
  Vec :: !Int -> Vec

local z = Vec 2

onceC, twoC, x :: Quote m => m Exp
onceC = [|1|]
twoC = [|2|]
x = [|$onceC + $twoC|]

main = do
  let x = "3"
  print x
