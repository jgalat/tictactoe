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

instance FromJSON Play where
  parseJSON (Object o)  = Play
                          <$> o .: "player"
                          <*> o .: "play"
  parseJSON _           = mzero

instance ToJSON User where
  toJSON (User i u)         = object [ "user_id" .= i, "username" .= u ]

instance ToJSON CellStatus where
  toJSON E = Number 0
  toJSON X = Number 1
  toJSON O = Number 2

instance ToJSON Board where
  toJSON (Board c0 c1 c2 c3 c4 c5 c6 c7 c8) =
    object  [ "c0" .= c0
            , "c1" .= c1
            , "c2" .= c2
            , "c3" .= c3
            , "c4" .= c4
            , "c5" .= c5
            , "c6" .= c6
            , "c7" .= c7
            , "c8" .= c8
            ]

instance ToJSON Game where
  toJSON (Game i p1 p2 t b)           =
    object [ "game_id" .= i, "player1" .= p1, "player2" .= p2, "turn" .= t, "board" .= b ]
  toJSON (SimpleGame i u1 Nothing)    =
    object [ "game_id" .= i, "player1" .= u1, "player2" .= Null ]
  toJSON (SimpleGame i u1 (Just u2))  =
    object [ "game_id" .= i, "player1" .= u1, "player2" .= u2 ]
