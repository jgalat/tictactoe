{-# LANGUAGE OverloadedStrings #-}
module DB where

import           Data.Int
import           Control.Applicative
import qualified Data.Text.Internal.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow

type Id = Int64

data User = User  { id        :: Id
                  , username  :: T.Text
                  }

instance FromRow User where
  fromRow = User <$> field <*> field

instance ToRow User where
  toRow (User _ u) = toRow [u]

tictactoeDB :: String
tictactoeDB = "tictactoe.db"

withDB :: String -> (Connection -> IO a) -> IO a
withDB s io = do
  conn <- open s
  a <- io conn
  close conn
  return a

withDB_ :: String -> (Connection -> IO ()) -> IO ()
withDB_ s io = do
  conn <- open s
  io conn
  close conn

setupDB :: IO ()
setupDB = withDB_ tictactoeDB $
  \conn -> do
    execute_ conn "CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, username TEXT)"

createNewUser :: T.Text -> IO Int64
createNewUser u = withDB tictactoeDB $
  \conn -> do
    execute conn "INSERT INTO user (username) VALUES (?)" (User 0 u)
    lastInsertRowId conn
