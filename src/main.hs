module Main where

import Data.Either ()
import Data.Word (Word8)

-- From Excercie 1.3
-- Sum types
data Deal a b
    = Thing a
    | Deuce b
    | Other Bool

data Mixed a = Mixed
    { mixedBit :: Word8
    , numerator :: a
    , denominator :: a
    }

main :: IO ()
main =
    print "Hello World"
