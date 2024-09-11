module CH2
  ( Unicode (U)
  , Hex
  )
where

import Numeric

newtype Hex a = Hex a

instance (Integral a, Show a) => Show (Hex a) where
  show (Hex a) = "0x" ++ showHex a ""

newtype Unicode where
  U :: Int -> Unicode
  deriving
    (Show)
    via (Hex Int)
