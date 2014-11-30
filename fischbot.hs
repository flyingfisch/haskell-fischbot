import Network
import System.IO
import Text.Printf
import Data.List
import Control.Monad

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
    listen handle

untilM :: Monad m => m Bool -> m ()
untilM m = do done <- m; if done then return () else untilM m

write :: Handle -> String -> String -> IO ()
write handle command args = do
    hPrintf handle "%s %s\r\n" command args
    printf "-> %s %s\n" command args

listen :: Handle -> IO ()
listen handle = forever $ do
    line <- hGetLine handle
    printf "<- %s\n" line

    handlePong handle line

handlePong :: Handle -> String -> IO ()
handlePong handle line = do
    if (words line !! 0 == "PING")
      then write handle "PONG" (words line !! 1)
      else return ()

waitForMOTD :: Handle -> IO ()
waitForMOTD handle = untilM $ do
    line <- hGetLine handle
    printf "<- (Awaiting MOTD) %s\n" line

    handlePong handle line
    if (words line !! 1 == "376")
        then do
            putStrLn "MOTD RECEIVED"
            return True
        else do
            return False


