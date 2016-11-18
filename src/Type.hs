module Type where

import qualified Data.Text.Internal.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import           Data.Int
import           Data.Aeson
import           Control.Applicative
import           Control.Monad

type Id = Int64

data User = User  { user_id   :: Id
                  , username  :: T.Text
                  }
          | Null

data Game = Game  { game_id   :: Id
                  , player1   :: Id
                  , player2   :: Id
                  , status    :: Int64
                  }
          | ExtendedGame  { game_id       :: Id
                          , user_player1  :: User
                          , user_player2  :: User
                          , status        :: Int64
                          }
