module App.Data where

import Control.Monad.Reader
import Network
import System.IO

type Net = ReaderT Bot IO
data Bot = Bot {
    socket :: Handle,
    server :: String,
    port :: String,
    chan :: String,
    nick :: String
}

creditText = "Made with a keyboard by flyingfisch"
gitHubRepo = "https://github.com/flyingfisch/haskell-fischbot/"
helpText = "!credits, !help, !info, !info-bugs, !info-contrib, !slap <name>, !say <message>"
infoText = "Hello, I am hFischbot. That is just the same as the other fischbot you all know and love, except in Haskelly goodness. More information can be obtained through !help, credits can be obtained with !credits"
