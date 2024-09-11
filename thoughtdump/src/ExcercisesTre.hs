{- Chapter 3 Example Problems-}
module ExcercisesTre where

-- compress :: (Eq a) => [a] -> [a]
-- compress [] = []
-- compress (x : xs) = x : compress (dropWhile (== x) xs)

flake x y z = print ([(n, 2 ^ n) | n <- [0 .. 20]])

mixer = print z
 where
  x = "f"
  y = (++) x x
  z = (++) y x
