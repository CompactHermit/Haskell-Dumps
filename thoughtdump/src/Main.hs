{-# LANGUAGE GADTs #-}

module Main where

import Data.Either ()
import Data.Word (Word8)

-- From Excercie 1.3
-- Sum types
data Deal a b where
    Thing :: a -> Deal a b
    Deuce :: b -> Deal a b
    Other :: Bool -> Deal a b

data Mixed a where
    Mixed ::
        {mixedBit :: !Word8, numerator :: a, denominator :: a} ->
        Mixed a

main = do
    let x = "3"
    print x
