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
  extendedGames <- liftIO (mapM extend games)
  json extendedGames
  where
    extend (Game i p1 0 s) = do
      u1 <- DB.getUser p1
      return (ExtendedGame i u1 Nothing s)
    extend (Game i p1 p2 s) = do
      u1 <- DB.getUser p1
      u2 <- DB.getUser p2
      return (ExtendedGame i u1 (Just u2) s)

invalidOperation :: ActionM ()
invalidOperation = text "Invalid operation"

-- isJSON :: ActionM () -> ActionM ()
-- isJSON a = do
--   ct <- header "Content-Type"
--   case ct of
--     Just "application/json" -> a
--     _                       -> invalidOperation

newUser :: ActionM ()
newUser = do
  username  <- param "username"
  user      <- liftIO (DB.createNewUser username)
  json user

app' :: ScottyM ()
app' = do
  middleware $ staticPolicy (noDots >-> addBase "static")
  get   "/"                   serveIndex
  get   "/games"              serveGames
  get   "/connect/:username"  newUser

app :: IO Application
app = scottyApp app'

runApp :: IO ()
runApp = scotty 5000 app'
