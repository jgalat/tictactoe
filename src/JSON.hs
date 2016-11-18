{-# LANGUAGE OverloadedStrings #-}
module JSON where

import           Data.Int
import           Data.Aeson
import           Control.Applicative
import           Control.Monad

import           Type

instance FromJSON User where
  parseJSON (Object o)  = User
                          <$> o .: "user_id"
                          <*> o .: "username"
  parseJSON _           = mzero

instance ToJSON User where
  toJSON (User i u)         = object [ "user_id" .= i, "username" .= u ]
  toJSON Type.Null          = Data.Aeson.Null

instance FromJSON Game where
  parseJSON (Object o) =  Game
                          <$> o .: "game_id"
                          <*> o .: "player1"
                          <*> o .: "player2"
                          <*> o .: "status"

instance ToJSON Game where
  toJSON (Game i p1 p2 s)         = object [ "game_id" .= i, "player1" .= p1, "player2" .= p2, "status" .= s ]
  toJSON (ExtendedGame i u1 u2 s) = object [ "game_id" .= i, "player1" .= u1, "player2" .= u2, "status" .= s ]
