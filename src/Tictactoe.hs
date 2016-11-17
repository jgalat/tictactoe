{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}
module Tictactoe (runApp, app) where

import qualified Data.Aeson as A
import           Network.Wai (Application)
import           Network.Wai.Middleware.Static
import           Web.Scotty
import qualified Data.Text.Internal.Lazy as T
import           Control.Monad.IO.Class (liftIO)

import qualified JSON as J
import qualified DB   as D

serveIndex :: ActionM ()
serveIndex = file "static/index.html"

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
    isJSON $ do u <- jsonData :: ActionM J.JSON
                i <- liftIO (D.createNewUser (J.username u))
                json (J.ConnectInfoResult i)

app' :: ScottyM ()
app' = do
  middleware $ staticPolicy (noDots >-> addBase "static")
  get   "/"         serveIndex
  post  "/connect"  newUser

app :: IO Application
app = scottyApp app'

runApp :: IO ()
runApp = scotty 5000 app'
