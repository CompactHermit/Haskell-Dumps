{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import Language.Haskell.TH.Syntax (Code)

power :: Int -> Int -> Int
power 0 p = 1
power n p = p * power (n - 1) p

main = do
    pure ()
