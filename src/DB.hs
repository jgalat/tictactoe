{-# LANGUAGE OverloadedStrings #-}
module DB where

import           Data.Int
import           Control.Applicative
import qualified Data.Text.Internal.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow

import           Type

instance FromRow User where
  fromRow = User <$> field <*> field

instance FromRow Game where
  fromRow = Game <$> field <*> field <*> field <*> field

instance ToRow User where
  toRow (User i u) = toRow (i, u)

instance ToRow Game where
  toRow (Game i p1 p2 s) = toRow (i, p1, p2, s)

tictactoeDB :: String
tictactoeDB = "tictactoe.db"

setupDB :: IO ()
setupDB = withConnection tictactoeDB $
  \conn -> do
    execute_ conn "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY NOT NULL, username TEXT NOT NULL)"
    execute_ conn "CREATE TABLE IF NOT EXISTS games (id INTEGER PRIMARY KEY NOT NULL, player1 INTEGER NOT NULL, player2 INTEGER NOT NULL, status INTEGER NOT NULL)"

createNewUser :: T.Text -> IO User
createNewUser u = withConnection tictactoeDB $
  \conn -> do
    execute conn "INSERT INTO users (username) VALUES (?)" (Only u)
    i <- lastInsertRowId conn
    return (User i u)

getUser :: Id -> IO User
getUser i = withConnection tictactoeDB $
  \conn -> do
    result <- query conn "SELECT * FROM users WHERE id = ?" (Only i)
    case result of
      [user]  -> return user
      _       -> undefined

getGames :: IO [Game]
getGames = withConnection tictactoeDB $
  \conn -> do
    query_ conn "SELECT * FROM games"
