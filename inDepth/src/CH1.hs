module CH1 (exc1, vocab1) where

import Data.Char
import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.Environment

-- | Text processing
-- Often the results in GHCi can expose the underlying type of our variable,
-- thus reducing the overcomplicated chains of functions
exc1 :: IO Int
exc1 = do
  text <- readFile "inDepth.cabal"
  let ws = words $ map toLower text
  let ws' = map (takeWhile isLetter . dropWhile (not . isLetter)) ws
  let cleanedWords = filter (not . null) ws'
  -- Here head may throw exceptions, it better to encapsulate the ws' as a maybe type
  let uniqueWords = map head $ group $ sort cleanedWords
  return (length uniqueWords)

vocab1 :: IO ()
vocab1 = do
  {-Reads the CLI Args -> List[Str]-}
  [fname] <- getArgs
  {-Read File content into buffer-}
  text <- TIO.readFile fname
  {-Transform text into a list of Words
   Note the following typeSigs
   * toCaseFold :: Text -> Text
    . Maps text to folded-case faster than `toLower`.
   . dropAround :: (Char -> Bool) -> Text -> Text
   --}
  let ws = map head $ group $ sort $ map T.toCaseFold $ filter (not . T.null) $ map (T.dropAround $ not . isLetter) $ T.words text
  {-Prints all words with whitespace delimiter-}
  TIO.putStrLn $ T.unwords ws
  print $ length ws

