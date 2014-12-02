module Irc.Listen
( listen
, waitForMOTD
) where

import Control.Monad
import Data.List
import Network
import System.IO
import Text.Printf

import Irc.Commands
import Irc.Write

untilM :: Monad m => m Bool -> m ()
untilM m = do done <- m; if done then return () else untilM m

listen :: Handle -> IO ()
listen handle = forever $ do
    line <- hGetLine handle
    printf "<- %s\n" line

    handlePong handle line

    handleCommands handle (words line)

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

handlePong :: Handle -> String -> IO ()
handlePong handle line = do
    if (words line !! 0 == "PING")
      then write handle "PONG" (words line !! 1)
      else return ()

