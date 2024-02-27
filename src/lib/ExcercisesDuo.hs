{-# LANGUAGE GADTs #-}

{- Chapter 2 Example Problems-}
module ExcercisesDuo where

_solution21a_TO :: IO ()
_solution21a_TO = do
    x <- print "Hello"
    print x
