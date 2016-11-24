{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}
module Application (runApp, app) where

import           Data.Maybe
import qualified Data.Aeson as A
import           Network.Wai (Application)
import           Network.Wai.Middleware.Static
import           Web.Scotty
import qualified Data.Text.Lazy as T
import           Control.Monad.IO.Class (liftIO)

import           Type
import qualified JSON as J
import qualified DB

serveIndex :: ActionM ()
serveIndex = file "static/index.html"

serveGames :: ActionM ()
serveGames = liftIO DB.getGames >>= json

invalidOperation :: ActionM ()
invalidOperation = json A.Null

isJSON :: ActionM () -> ActionM ()
isJSON a = do
  ct <- header "Content-Type"
  case ct of
    Just "application/json" -> a
    _                       -> invalidOperation

newUser :: ActionM ()
newUser = do
  username  <- param "username"
  mu        <- liftIO (DB.getUser' username)
  maybe (liftIO (DB.createNewUser username)) return mu >>= json

newGame :: ActionM ()
newGame = isJSON $
  do
    user <- jsonData :: ActionM User
    m    <- liftIO (DB.createNewGame user)
    maybe invalidOperation json m

joinGame :: ActionM ()
joinGame = isJSON $
  do
    gameId  <- param "gameid"
    user    <- jsonData :: ActionM User
    m       <- liftIO (DB.joinGame user gameId)
    maybe invalidOperation json m

watchGame :: ActionM ()
watchGame = do
  gameId  <- param "gameid"
  game    <- liftIO (DB.getGame gameId)
  maybe invalidOperation json game

app' :: ScottyM ()
app' = do
  middleware $ staticPolicy (noDots >-> addBase "static")
  get   "/"                   serveIndex
  get   "/games"              serveGames
  get   "/connect/:username"  newUser
  get   "/watch/:gameid"      watchGame
  post  "/newgame"            newGame
  post  "/join/:gameid"       joinGame
  notFound                    invalidOperation

app :: IO Application
app = scottyApp app'

runApp :: IO ()
runApp = scotty 5000 app'
