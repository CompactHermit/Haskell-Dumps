module Main (main) where

len :: [a] -> Int
len [] = 0
len (x : xs) = len xs + 1

len' :: [a] -> Int -> Int
len' [] acc = acc
len' (x : xs) acc = len' xs (1 + acc)

main :: IO ()
main = print $ len' [1 :: Int .. 200000 :: Int] 0
