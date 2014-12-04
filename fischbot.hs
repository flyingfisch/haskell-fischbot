import Control.Exception
import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Network
import System.IO
import System.Environment
import Text.Printf

import App.Data

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

motdHandler :: Handle -> Net ()
motdHandler handle = do
    line <- io $ hGetLine handle
    io $ printf "<- (Awaiting MOTD) %s\n" line

    pongHandler handle line

    if (words line !! 1 == "376")
      then do
          io $ putStrLn "MOTD RECEIVED"
          return ()
      else do
          motdHandler handle

listen :: Handle -> Net ()
listen handle = do
    line <- io (hGetContents handle)
    io $ putStrLn line

pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

write :: String -> String -> Net ()
write command arg = do
    handle <- asks socket
    io $ hPrintf handle "%s %s\r\n" command arg
    io $ printf "-> %s %s\n" command arg

io :: IO a -> Net a
io = liftIO
