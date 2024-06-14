{-# HLINT ignore "Unused LANGUAGE pragma" #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Templates where

import GHC.Float (Double, int2Double)

veryLargeMath :: Int -> Double
veryLargeMath = int2Double
