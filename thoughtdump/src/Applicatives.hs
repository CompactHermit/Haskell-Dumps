{-# LANGUAGE GADTs #-}

module Applicatives (f') where

import Data.Aeson
import Data.Bifunctor
import Data.Char
import Data.Int
import Data.Maybe
import qualified Data.Text as T (Text, pack)

{-Following the wiki https://en.wikibooks.org/wiki/Haskell/Applicative_functors-}
-- Imagine having the following type-}

-- | Awooga
-- Ooga
f' :: Maybe String -> T.Text
f' (Just x) = x'
 where
  x' = T.pack (x :: String)
f' Nothing = T.pack "var-not-found"
