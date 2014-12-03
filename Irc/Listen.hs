module Irc.Listen
( listen
, waitForMOTD
) where

import Control.Monad
import Control.Monad.Reader
import Data.List
import Network
import System.IO
import Text.Printf

import App.Data
import Irc.Commands
import Irc.Write

untilM :: Monad m => m Bool -> m ()
untilM m = do done <- m; if done then return () else untilM m

listen :: IO ()
listen = forever $ do
    handle <- asks socket
    line <- hGetLine handle
    printf "<- %s\n" line

    handlePong handle line

    liftIO $ handleCommands (words line)

waitForMOTD :: Net ()
waitForMOTD = untilM $ do
    handle <- asks socket
    line <- hGetLine handle
    printf "<- (Awaiting MOTD) %s\n" line

    handlePong handle line
    if (words line !! 1 == "376")
        then do
            putStrLn "MOTD RECEIVED"
            return True
        else do
            return False

handlePong :: Handle -> String -> Net ()
handlePong handle line = do
    if (words line !! 0 == "PING")
      then liftIO $ write "PONG" (words line !! 1)
      else liftIO $ return ()

