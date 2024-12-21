{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}

module CH2
  ( Turn (..),
    Direction (..),
    orient,
    rotateFromFile,
    orientFromFile,
    rotateMany,
    rotateMany',
    rotateManySteps,
  )
where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Fmt (Buildable, build, fmt, nameF, (+||), (||+))
import Fmt.Internal.Formatters (unwordsF)
import System.Environment (getArgs)

-- | Direction Objects ::
-- The following typeclasses are derived
-- Eq:: Equality for same values and inequality for others
-- Enum:: Enumerates from right->left the objects
--      e.g:: succ North = East
-- Bounded:: Min => left | Max => Right
--      e.g:: minBound
-- Show:: Print Data Constructor literal
-- data Direction = North | East | South | West
--   deriving (Eq, Enum, Bounded, Show)
--
-- | Turn :: Either noop, L/R, or around
data Turn = TNone | TLeft | TRight | TAround
  deriving (Eq, Enum, Bounded, Show)

-- | A class which is only applicable for types implementing Eq/Bounded/Enum
class (Eq a, Enum a, Bounded a) => CyclicEnum a where
  cpred :: a -> a
  cpred a
    -- \| (a == minBound) = maxBound
    | a == minBound = maxBound
    | otherwise = pred a
  csucc :: a -> a
  csucc a
    -- \| (a == maxBound) = minBound
    | a == maxBound = minBound
    | otherwise = succ a

-- | Deriving Direction here
data Direction = North | East | South | West
  deriving (Eq, Enum, Bounded, Show, CyclicEnum)

-- | rotate:: CounterClockwise rotation
-- | TLeft: N->W->S->E->N
-- | TRight: N->E->S->W->N
-- | TAround: N<->S, E<->W
rotate :: Turn -> Direction -> Direction
rotate a
  | a == TNone = id
  | a == TLeft = cpred
  | a == TRight = csucc
  | otherwise = cpred . cpred -- or csucc  . csucc

-- | orient :: find a Turn to change the orientation. Takes a Direction_I and Direction_F and produces a Turn
-- orient N S = (TAround)
-- orient N E = (TRight)
-- |We can Shorthand [TAround, TLeft,TRight, TNone] bcs we derived ENum
orient :: Direction -> Direction -> Turn
orient d1 d2 = head $ filter (\dir -> rotate dir d1 == d2) [TNone .. TAround]

-- | every:: Takes some a which derives Enum/Bounded, and returns a list of the object
-- | enumFrom :: Gives us Enum a
-- | minBound :: Gives us Bounded a
every :: (Enum a, Bounded a) => [a]
every = enumFrom minBound

-- a = rotate every North

-- | orient' :: Rewrite of orient with every generic function
--  | Uses every, rotation
orient' d1 d2 = head $ filter (\t -> rotate t d1 == d2) every

-- | rotateMany
-- | Folds over a list of rotations,
-- rotateMany d1 (x:xs) = ( .... (rotate xs (rotate x d1)) As rotate Takes Turn ->
-- Direction, we simply switch the inputs for linearity, else we'd have to
-- define variables
rotateMany :: Direction -> [Turn] -> Direction
rotateMany = foldl (flip rotate)

-- | rotateManyDirection ::
--   Essentially scanl (rotate), but rotate flipped
rotateManySteps :: Direction -> [Turn] -> [Direction]
rotateManySteps = scanl (flip rotate)

-- rotateManyDirection _ [] = []
-- rotateManyDirection d (x:xs) =  rs : rotateManyDirection rs xs
--     where
--         rs = rotate x d

-- | orientMany ::
-- Takes list of directions, orient
-- needs to bind list, as we are reducing alongside the list
-- zipWith orient [North East South West] [East, South, West]
-- [orient North East, orient East South]
orientMany :: [Direction] -> [Turn]
orientMany ds@(_ : _ : _) = zipWith orient ds (tail ds)
orientMany _ = []

{-2.13 COmbining turns using Semigroup-}

instance Semigroup Turn where
  TNone <> t = t
  TLeft <> TLeft = TAround
  TRight <> TRight = TAround
  TLeft <> TRight = TNone
  TRight <> TAround = TLeft
  t1 <> t2 = t2 <> t1

instance Monoid Turn where
  mempty = TNone

rotateMany' :: Direction -> [Turn] -> Direction
rotateMany' dir ts = rotate (mconcat ts) dir

arb = TRight :| [TLeft]

{-2.14 Reading Files and Show-}
-- requires StandaloneDeriving
deriving instance Read Direction

deriving instance Read Turn

deriving instance Ord Turn

instance Buildable Direction where
  build North = "N"
  build East = "E"
  build South = "S"
  build West = "W"

instance Buildable Turn where
  build TNone = "--"
  build TLeft = "->"
  build TRight = "<-"
  build TAround = "||"

rotateFromFile :: Direction -> FilePath -> IO ()
rotateFromFile dir fpath = do
  f <- readFile fpath
  let turns = map read $ lines f
      finalDir = rotateMany' dir turns
      dirs = rotateManySteps dir turns
  -- here:: +|| and ||+ take 2 builders and string_concats them
  fmt $ "Final Dir:: " +|| finalDir ||+ "\n"
  fmt $ nameF "Intermediette Dirs ::" (unwordsF dirs)

orientFromFile :: FilePath -> IO ()
orientFromFile fpath = do
  f <- readFile fpath
  let dirs = map read $ lines f
  fmt $ nameF "Turns::" (unwordsF $ orientMany dirs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["-r", fname, dir] -> rotateFromFile (read dir) fname
    ["-o", fname] -> orientFromFile fname
    _ ->
      putStrLn $
        "Usage: locator -o <filename>\n"
          ++ "locator -r <filename> <directions>"

