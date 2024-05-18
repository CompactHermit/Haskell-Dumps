{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE DerivingStrategies #-}
{-# HLINT ignore "Use newtype instead of data" #-}
-- This is actually retarded
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module OpticsPrism (
    shiftAtomX,
    Point (..),
    Atom (..),
    Molecule (..),
) where

import Control.Lens (makeLenses)
import Control.Lens hiding (element)
import Control.Lens.TH
import GHC.Generics qualified as G
import Language.Haskell.TH.Optics
import Optics (Iso, Iso')

{-following https://github.com/Gabriella439/Haskell-Lens-Tutorial-Library-}

data Atom = Atom {_element :: String, _point :: Point} deriving (Show)

data Point = Point {_x :: Double, _y :: Double} deriving (Show)
data Molecule = Molecule {_atomz :: [Atom]} deriving (Show)

$(makeLenses ''Atom)
$(makeLenses ''Point)
$(makeLenses ''Molecule)

shiftAtomX :: Atom -> Atom
shiftAtomX = over (point . x) (+ 1)

-- shiftMoleculeX :: Molecule -> Molecule
-- shiftMoleculeX = over (atomz . traverse . point . x) (+ 1)

atom = Atom{_element = "c", _point = Point{_x = 1.0, _y = 2.0}}

atom1 = Atom{_element = "C", _point = Point{_x = 1.0, _y = 2.0}}
atom2 = Atom{_element = "O", _point = Point{_x = 3.0, _y = 4.0}}
molecule = Molecule{_atomz = [atom1, atom2]}
