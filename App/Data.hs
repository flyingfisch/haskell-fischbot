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

infoText = "Hello, I am hFischbot. That is just the same as the other fischbot you all know and love, except in Haskelly goodness. More information can be obtained through !help, credits can be obtained with !credits"
creditText = "Made with a keyboard by flyingfisch"
