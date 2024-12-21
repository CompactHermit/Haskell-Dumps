{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

-- Very fucking bad, but since this's for tests, it's fine

module Turns_spec () where

import CH2 (Direction (..), Turn (..), orient, rotateMany, rotateMany')
import Control.Monad (replicateM)
import Data.List (nub, sort)
import System.Random.Stateful (Uniform (uniformM), UniformRange (uniformRM), getStdRandom, uniform)
import Test.Hspec (describe, hspec, it, shouldBe)
import Test.Hspec.QuickCheck ()

instance UniformRange Direction where
  uniformRM (a, b) rng = do
    res <- uniformRM (fromEnum a :: Int, fromEnum b) rng -- Int -> toEnum::Direction
    pure $ toEnum res -- IO = m, res Direction --> IO Direction

instance Uniform Direction where
  uniformM = uniformRM (minBound, maxBound)

instance UniformRange Turn where
  uniformRM (a, b) rng = do
    res <- uniformRM (fromEnum a :: Int, fromEnum b) rng -- Int -> toEnum::Turn
    pure $ toEnum res -- IO = m, res Turn --> IO Turn

instance Uniform Turn where
  uniformM = uniformRM (minBound, maxBound)

-- | Composes a Uniform a into an IO object, essentially an fmap into IO
uniformIO :: (Uniform a) => IO a
uniformIO = getStdRandom uniform

-- | Using replicateM bcs we need to collect many IO objectss
uniformsIO :: (Uniform a) => Int -> IO [a]
uniformsIO n = replicateM n uniformIO

-- | Implement a random Turn method for `Turn` + `Direction` + write a random file,
randomTurn :: Int -> IO [Turn]
randomTurn = uniformsIO

randomDirection :: Int -> IO [Direction]
randomDirection = uniformsIO

writeToFileRandom :: (Uniform a, Show a) => Int -> (Int -> IO [a]) -> FilePath -> IO ()
writeToFileRandom n genF fname = do
  randG <- genF n
  writeFile fname $ unlines $ map show randG

{- The actual test-specs -}
allTurnSpec :: Bool
allTurnSpec = sort (nub [orient dir1 dir2 | dir1 <- [], dir2 <- []]) == [TRight .. TLeft]

rotationIsMonoid :: [Turn] -> Bool
rotationIsMonoid ts = and [rotateMany d ts == rotateMany' d ts | d <- [North .. West]]

main :: IO ()
main = hspec $ do
  describe "CH2" $ do
    it "orient::uses all turns" $ do
      allTurnSpec `shouldBe` True
    it "rotation::Statifies Monoid Condition" $ do
      ts <- randomTurn 1000
      rotationIsMonoid ts `shouldBe` True

