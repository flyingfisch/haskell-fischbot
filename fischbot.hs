import Network
import System.IO

import Irc.Base

server = "irc.afternet.org"
port = 6667
chan = "#fischbot"
nick = "hFischbot"

main = do
    handle <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering handle NoBuffering
    write handle "NICK" nick
    write handle "USER" (nick ++ " 0 * :haskell-fischbot")
    waitForMOTD handle
    write handle "JOIN" chan
    listen handle

