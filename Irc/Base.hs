module Irc.Base
( write
, listen
, waitForMOTD
) where

import Control.Monad
import Data.List
import Network
import System.IO
import Text.Printf

untilM :: Monad m => m Bool -> m ()
untilM m = do done <- m; if done then return () else untilM m

write :: Handle -> String -> String -> IO ()
write handle command args = do
    hPrintf handle "%s %s\r\n" command args
    printf "-> %s %s\n" command args

writeToChan :: Handle -> String -> String -> IO ()
writeToChan handle chan message = write handle ("PRIVMSG " ++ chan) (':':message)

listen :: Handle -> IO ()
listen handle = forever $ do
    line <- hGetLine handle
    printf "<- %s\n" line

    handlePong handle line

    handleCommands handle (words line)

handlePong :: Handle -> String -> IO ()
handlePong handle line = do
    if (words line !! 0 == "PING")
      then write handle "PONG" (words line !! 1)
      else return ()

handleCommands :: Handle -> [String] -> IO ()
handleCommands handle (ident:irccmd:chan:command:message) = do
    case (lookup command commandSet) of (Just action) -> action handle chan (unwords message)
                                        (_) -> return ()
handleCommands handle (_) = return ()

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





commandSet = [(":test", test)]

test :: Handle -> String -> String -> IO ()
test handle chan _ = writeToChan handle chan "Test received."
