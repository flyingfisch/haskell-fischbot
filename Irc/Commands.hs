module Irc.Commands
( handleCommands
) where

import Control.Monad
import Data.List
import Network
import System.IO
import Text.Printf

import Irc.Write

-- Command set list and function to handle commands
commandSet =
    [
        (":test", test),
        (":!say", say)
    ]

handleCommands :: Handle -> [String] -> IO ()
handleCommands handle (ident:irccmd:chan:command:message) = do
    case (lookup command commandSet) of (Just action) -> action handle chan (unwords message)
                                        (_) -> return ()
handleCommands handle (_) = return ()

-- Commands
test :: Handle -> String -> String -> IO ()
test handle chan _ = writeToChan handle chan "Test received."

say :: Handle -> String -> String -> IO ()
say handle chan message = writeToChan handle chan message
