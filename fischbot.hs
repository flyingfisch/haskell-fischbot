import Control.Exception
import Control.Monad
import Control.Monad.Reader
import Network
import System.IO
import System.Environment
import Text.Printf

import App.Data
import App.Functions
import Irc.Write
import Irc.Listen

server = "irc.afternet.org"
port = 6667
chan = "#fischbot"
nick = "hFischbot"

main :: IO ()
main = bracket connect disconnect loop
    where
    disconnect = hClose . socket
    loop st = runReaderT run st

connect :: IO Bot
connect = do
    handle <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering handle NoBuffering
    return $ Bot handle

run :: Net ()
run = do
    write "NICK" nick
    write "USER" (nick ++ " 0 * :haskell-fischbot")

    asks socket >>= motdHandler

    write "JOIN" chan
    asks socket >>= listen

    return ()

