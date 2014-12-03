import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Network
import System.IO
import System.Environment
import Text.Printf

type Net = ReaderT Bot IO
data Bot = Bot { socket :: Handle }

server = "irc.afternet.org"
port = 6667
chan = "#fischbot"
nick = "hFischbot"

main = do
    fischbotGlobals <- connect
    runReaderT run fischbotGlobals

connect :: IO Bot
connect = do
    handle <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering handle NoBuffering
    return (Bot handle)

run :: Net ()
run = do
    write "NICK" nick
    write "USER" (nick ++ " 0 * :haskell-fischbot")

    asks socket >>= motdHandler

motdHandler :: Handle -> Net ()
motdHandler handle = untilM $ do
    line <- hGetLine handle
    printf "<- (Awaiting MOTD) %s\n" line

    return True


pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

listen :: Net ()
listen = do
    handle <- asks socket
    line <- io (hGetContents handle)
    io $ putStrLn line

write :: String -> String -> Net ()
write command arg = do
    handle <- asks socket
    io $ hPrintf handle "%s %s\r\n" command arg
    io $ printf "-> %s %s\n" command arg

io :: IO a -> Net a
io = liftIO

untilM :: Monad m => m Bool -> m ()
untilM m = do done <- m; if done then return () else untilM m
