{-# LANGUAGE GADTs #-}

module Main where

data Parity = Even | Odd

instance Num Parity where
  Even + Even = Even
  Odd + Odd = Even
  Even + Odd = Odd
  Odd + Even = Odd
  p1 - p2 = p1 + p2
  Odd * Odd = Odd
  _ * _ = Even
  negate p = p
  abs p = p
  signum p = p
  fromInteger p
    | even p = Even
    | otherwise = Odd

-- | ParityIntegers
-- |(perf): in memory, this'll be 1 word `constructor` + 2 pointers to `parity` and `integer`.
-- |(perf): Since x86_64, this'll be 8 bit per item, for 24 items
data ParityIntegers = MkPI Parity Integer

piFromInt :: Integer -> ParityIntegers
piFromInt n
  | even n = MkPI Even n
  | otherwise = MkPI Odd n

addPi :: ParityIntegers -> ParityIntegers -> ParityIntegers
addPi (MkPI p0 i0) (MkPI p1 i1) = MkPI (p1 + p0) (i0 + i1)

biPI = go (piFromInt 0) [1 .. 100000]
  where
    go :: ParityIntegers -> [Integer] -> ParityIntegers
    go acc [] = acc
    go acc (x : xs) = go (addPi acc (piFromInt x)) xs

intFromPi :: ParityIntegers -> Integer
intFromPi (MkPI _ x) = x

-- | Run with `ghc ./src/main.hs & ./src/Main +RTS -s`
main :: IO ()
main = print (intFromPi biPI)
