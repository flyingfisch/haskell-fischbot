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
commandSet :: [(String, Handle -> String -> String -> IO ())]
commandSet =
    [
        (":test", test),
        (":!say", say),
        (":!intro", intro)
    ]

handleCommands :: Handle -> [String] -> IO ()
handleCommands handle (ident:irccmd:chan:command:message) = do
    case (lookup command commandSet) of (Just action) -> action handle chan (unwords message)
                                        (_) -> return ()
handleCommands handle (_) = return ()

-- Commands
test handle chan _ = writeToChan handle chan "Test received."

say handle chan message = writeToChan handle chan message

intro handle chan "" = writeToChan handle chan "You didn't tell me who to introduce!"
intro handle chan name = writeToChan handle chan (name ++ ", You should introduce yourself: http://community.casiocalc.org/topic/5677-introduce-yourself")

