{-# LANGUAGE OverloadedStrings #-}
module DB where

import           Data.Int
import           Data.Maybe
import           Control.Applicative
import qualified Data.Text.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromField
import           Database.SQLite.Simple.ToField
import           Database.SQLite.Simple.FromRow
import           Database.SQLite.Simple.Internal
import           Random.IO

import           Type

instance FromField CellStatus where
  fromField (Field (SQLInteger i) _) =
    case i of
      0 -> pure E
      1 -> pure X
      2 -> pure O
      _ -> error "Int must be between 0 and 2"

instance FromRow Int where
  fromRow = field

instance FromRow User where
  fromRow = User <$> field <*> field

instance FromRow Game where
  fromRow = Game
            <$> field
            <*> field
            <*> field
            <*> field
            <*> (Board
                <$> field
                <*> field
                <*> field
                <*> field
                <*> field
                <*> field
                <*> field
                <*> field
                <*> field)

instance ToField CellStatus where
  toField E = toField (0 :: Int)
  toField X = toField (1 :: Int)
  toField O = toField (2 :: Int)

instance ToRow User where
  toRow (User i u) = toRow (i, u)

simpleGame :: Game -> IO Game
simpleGame (Game i p1 0 _ _) = do
  u1 <- getUser p1
  return (SimpleGame i (fromJust u1) Nothing)
simpleGame (Game i p1 p2 _ _) = do
  u1 <- getUser p1
  u2 <- getUser p2
  return (SimpleGame i (fromJust u1) u2)

tictactoeDB :: String
tictactoeDB = "tictactoe.db"

setupDB :: IO ()
setupDB = withConnection tictactoeDB $
  \conn -> do
    execute_ conn "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY NOT NULL, username TEXT NOT NULL)"
    execute_ conn "CREATE TABLE IF NOT EXISTS games (id INTEGER PRIMARY KEY NOT NULL, player1 INTEGER NOT NULL, player2 INTEGER NOT NULL DEFAULT 0, turn INTEGER NOT NULL DEFAULT 0, c0 INTEGER NOT NULL DEFAULT 0, c1 INTEGER NOT NULL DEFAULT 0, c2 INTEGER NOT NULL DEFAULT 0, c3 INTEGER NOT NULL DEFAULT 0, c4 INTEGER NOT NULL DEFAULT 0, c5 INTEGER NOT NULL DEFAULT 0, c6 INTEGER NOT NULL DEFAULT 0, c7 INTEGER NOT NULL DEFAULT 0, c8 INTEGER NOT NULL DEFAULT 0)"

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
        execute conn "INSERT INTO games (player1) VALUES (?)" (Only (user_id u))
        gameId <- lastInsertRowId conn
        return (Just (SimpleGame (fromIntegral gameId) u Nothing))
      else return Nothing

joinGame :: User -> Id -> IO (Maybe Game)
joinGame u gi = withConnection tictactoeDB $
  \conn -> do
    cu    <- checkUser conn u
    game  <- getGame gi
    maybe (return Nothing)
          (\(Game gi p1 p2 t b) ->
            let i = user_id u
            in if cu && p2 == 0
              then do
                execute conn "UPDATE games SET player2 = ? WHERE id = ?" [i, gi]
                return (Just (Game gi p1 i p1 b))
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
  \conn -> query_ conn "SELECT * FROM games" >>= mapM simpleGame
