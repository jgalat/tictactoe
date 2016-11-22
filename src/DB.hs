{-# LANGUAGE OverloadedStrings #-}
module DB where

import           Data.Int
import           Data.Maybe
import           Control.Applicative
import qualified Data.Text.Internal.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow

import           Type

instance FromRow Int where
  fromRow = field

instance FromRow User where
  fromRow = User <$> field <*> field

instance FromRow Game where
  fromRow = Game <$> field <*> field <*> field <*> field

instance ToRow User where
  toRow (User i u) = toRow (i, u)

instance ToRow Game where
  toRow (Game i p1 p2 s) = toRow (i, p1, p2, s)

extendGame :: Game -> IO Game
extendGame (Game i p1 0 s) = do
  u1 <- getUser p1
  return (ExtendedGame i (fromJust u1) Nothing s)
extendGame (Game i p1 p2 s) = do
  u1 <- getUser p1
  u2 <- getUser p2
  return (ExtendedGame i (fromJust u1) u2 s)

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
    return (User (fromIntegral i) u)

checkUser :: Connection -> User -> IO Bool
checkUser conn u = do
  let i = user_id u
  r0 <- query conn "SELECT id FROM users where id = ?" (Only i) :: IO [Id]
  r1 <- query conn "SELECT id FROM games where player1 = ? OR player2 = ?" [i, i] :: IO [Id]
  return (not (null r0) && null r1)

createNewGame :: User -> IO (Maybe Game)
createNewGame u = withConnection tictactoeDB $
  \conn -> do
    b <- checkUser conn u
    if b
      then do
        execute conn "INSERT INTO games (player1, player2, status) VALUES (?, ?, ?)" [user_id u, 0, 0]
        gameId <- lastInsertRowId conn
        return (Just (ExtendedGame (fromIntegral gameId) u Nothing 0))
      else return Nothing

joinGame :: User -> Id -> IO (Maybe Game)
joinGame u gi = withConnection tictactoeDB $
  \conn -> do
    b     <- checkUser conn u
    game  <- getGame gi
    maybe (return Nothing)
          (\(Game gi p1 p2 s) ->
            let i = user_id u
            in if b && p2 == 0
              then do
                execute conn "UPDATE games SET player2 = ? WHERE id = ?" [i, gi]
                return (Just (Game gi p1 i s))
              else return Nothing) game

getUser :: Id -> IO (Maybe User)
getUser i = withConnection tictactoeDB $
  \conn -> do
    result <- query conn "SELECT * FROM users WHERE id = ?" (Only i)
    case result of
      [user]  -> return (Just user)
      _       -> return Nothing

getGame :: Id -> IO (Maybe Game)
getGame i = withConnection tictactoeDB $
  \conn -> do
    result <- query conn "SELECT * FROM games where id = ?" (Only i)
    case result of
      [game]  -> return (Just game)
      _       -> return Nothing

getGames :: IO [Game]
getGames = withConnection tictactoeDB $
  \conn -> do
    query_ conn "SELECT * FROM games"
