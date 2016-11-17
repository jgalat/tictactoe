{-# LANGUAGE OverloadedStrings #-}
module JSON where

import           Data.Int
import           Data.Aeson
import qualified Data.Text.Internal.Lazy as T
import           Control.Applicative
import           Control.Monad

data JSON = ConnectInfo         { username   :: T.Text }
          | ConnectInfoResult   { _id  :: Int64 }

instance FromJSON JSON where
  parseJSON (Object o)  = ConnectInfo
                          <$> o .: "username"
  parseJSON _           = mzero

instance ToJSON JSON where
  toJSON (ConnectInfoResult i) = object [ "id" .= i ]
