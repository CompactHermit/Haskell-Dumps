{-# LANGUAGE DerivingStrategies #-}

module OpticsPrism where

import Data.Monoid (Any)
import GHC.Generics (Generic)
import Language.Haskell.TH.Optics
import Optics (Iso, Iso')
import Text.Printf (printf, toChar)

{- Usage Of Iso -}

{- Usage of Lens
 (https://stackoverflow.com/questions/10788261/what-are-lenses-used-useful-for#10788698)
 -}

data Vec2 = Vec2
    { vecX :: Float
    , vecY :: Float
    }

-- Nested Data Struct
data Mat2 = Mat2
    { matCol1 :: Vec2
    , matCol2 :: Vec2
    }

instance Show Vec2 where
    show vec =
        -- let
        --     x = vecX vec
        --     y = vecY vec
        --  in
        printf "Vec2 Contains the following types:: \n Pos_1 := %f \n Pos_2 := %f" (vecX vec) (vecY vec)

getVecUnder =
    let
        -- Defining Struct
        vec = Vec2 2 3
        -- Reading the component of vec
        foo = vecX vec
        -- Creating vec2, with vecY set to vecX
        vec2 = vec{vecY = foo}
        mat = Mat2 vec2 vec2
     in
        -- defines a stuct
        mat{matCol2 = (matCol2 mat){vecX = 4}}

data ID = ID {member :: Int}

getter :: ID -> Int
getter d = member d

setter :: Int -> ID -> ID
setter d m = m{member = d}

lensInstance :: (ID -> Int, Int -> ID -> ID)
lensInstance = (getter, setter)
