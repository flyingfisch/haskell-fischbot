module App.Data
( Net (..)
, Bot (..)
) where

import Control.Monad.Reader
import Network
import System.IO

type Net = ReaderT Bot IO
data Bot = Bot { socket :: Handle }

