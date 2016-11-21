{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}
module Application (runApp, app) where

import qualified Data.Aeson as A
import           Network.Wai (Application)
import           Network.Wai.Middleware.Static
import           Web.Scotty
import qualified Data.Text.Internal.Lazy as T
import           Control.Monad.IO.Class (liftIO)

import           Type
import qualified JSON as J
import qualified DB

serveIndex :: ActionM ()
serveIndex = file "static/index.html"

serveGames :: ActionM ()
serveGames = do
  games <- liftIO DB.getGames
  liftIO (mapM DB.extendGame games) >>= json

invalidOperation :: ActionM ()
invalidOperation = text "Invalid operation"

isJSON :: ActionM () -> ActionM ()
isJSON a = do
  ct <- header "Content-Type"
  case ct of
    Just "application/json" -> a
    _                       -> invalidOperation

newUser :: ActionM ()
newUser = do
  username  <- param "username"
  liftIO (DB.createNewUser username) >>= json

newGame :: ActionM ()
newGame = isJSON $
  do
    user <- jsonData :: ActionM User
    b    <- liftIO (DB.checkUser (user_id user))
    if b
      then (liftIO (DB.createNewGame user) >>= json)
      else invalidOperation

app' :: ScottyM ()
app' = do
  middleware $ staticPolicy (noDots >-> addBase "static")
  get   "/"                   serveIndex
  get   "/games"              serveGames
  get   "/connect/:username"  newUser
  post  "/newgame"            newGame

app :: IO Application
app = scottyApp app'

runApp :: IO ()
runApp = scotty 5000 app'
