module Main where

import GHC.IO.Buffer ()

data Pair a = Pair a a deriving (Show)

instance Functor Pair where
  fmap f_ (Pair a b) = Pair (f_ a) (f_ b)

main = do
  pure ()
