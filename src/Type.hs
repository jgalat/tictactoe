module Type where

import qualified Data.Text.Internal.Lazy as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import           Data.Int
import           Data.Aeson
import           Control.Applicative
import           Control.Monad

type Id = Int

data User = User  { user_id   :: Id
                  , username  :: T.Text
                  }

data Game = Game  { game_id   :: Id
                  , player1   :: Id
                  , player2   :: Id
                  , status    :: Int
                  }
          | ExtendedGame  { game_id       :: Id
                          , user_player1  :: User
                          , user_player2  :: Maybe User
                          , status        :: Int
                          }
