module Main where

import           DB (setupDB)
import           Application (runApp)

main :: IO ()
main = do
  setupDB
  runApp
