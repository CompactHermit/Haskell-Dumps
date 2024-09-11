{-# LANGUAGE GADTs #-}

module Tree where

import Data.Kind ()

-- data Tree a = Leaf a | Node (Tree a) (Tree a)
data Tree a where
  Leaf :: a -> Tree a
  Node :: (Tree a) -> (Tree a) -> Tree a

data TreeF a r where
  LeafF :: a -> TreeF a r
  NodeF :: r -> r -> TreeF a r
  deriving (Show)

exampleTree :: Tree Int
exampleTree = Node (Node (Leaf 3) (Leaf 4)) (Node (Leaf 1) (Leaf 2))

exampleTreeF :: TreeF Int String
exampleTreeF = NodeF "String" "Foldables"
