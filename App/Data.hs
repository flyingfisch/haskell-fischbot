module App.Data
( Net
, Bot
, socket
, server
, port
, chan
, nick
) where

import Control.Monad
import Control.Monad.Reader
import Network
import System.IO

type Net = ReaderT Bot IO
data Bot = Bot { socket :: Handle }


server = "irc.afternet.org"
port = 6667
chan = "#fischbot"
nick = "hFischbot"
