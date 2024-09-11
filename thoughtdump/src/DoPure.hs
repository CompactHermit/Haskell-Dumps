module DoPure where

import GHC.IO.Handle (hClose_help)

comand = do
  x <- print "hello"
  pure ()
