module Main where

import           DB (setupDB)
import           Tictactoe (runApp)

main :: IO ()
main = do
  setupDB
  runApp
