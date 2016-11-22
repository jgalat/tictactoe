module Type where

import qualified Data.Text.Lazy as T
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

data CellStatus = E | X | O

data Board = Board  { c0 :: CellStatus
                    , c1 :: CellStatus
                    , c2 :: CellStatus
                    , c3 :: CellStatus
                    , c4 :: CellStatus
                    , c5 :: CellStatus
                    , c6 :: CellStatus
                    , c7 :: CellStatus
                    , c8 :: CellStatus
                    }

data Game = Game  { game_id   :: Id
                  , player1   :: Id
                  , player2   :: Id
                  , turn      :: Id
                  , board     :: Board
                  }
          | SimpleGame  { game_id       :: Id
                        , user_player1  :: User
                        , user_player2  :: Maybe User
                        }
