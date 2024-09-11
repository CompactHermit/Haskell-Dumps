module CH1
  (
  )
where

import Control.Applicative
import Control.Lens
import Data.Char
import qualified Data.Map as M
import qualified Data.Set as S
import qualified Data.Text as T
import GHC.TypeLits (Nat)
import Language.Haskell.TH.Ppr (opPrec)
import Language.Haskell.TH.Syntax (Con (GadtC), Extension (TemplateHaskell))

optical1 =
  let stories = ["a book called", "ooga booga", "scary spooky"]; x = 4; foo = 11
   in over (traversed . filtered ((> foo) . length)) (\s -> take x s ++ "...") stories

append :: [a] -> [a] -> [a]
append [] [] = []
append (x : xs) [] = x : xs
append [] (y : ys) = y : ys
append (x : xs) (y : ys) = append (x : xs : y) (ys)
