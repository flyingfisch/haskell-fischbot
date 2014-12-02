module Irc.Commands
( handleCommands
) where

import Control.Monad
import Data.List
import Network
import System.IO
import Text.Printf

import Irc.Write

-- version
version = "0.1b"

-- Command set list and function to handle commands
commandSet :: [(String, Handle -> String -> String -> IO ())]
commandSet =
    [
        (":!info", info),
        (":!info-bugs", infoBugs),
        (":!info-contrib", infoContrib),
        (":!intro", intro),
        (":test", test),
        (":!say", say),
        (":!version", sendVersion)
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

info handle chan _ = writeToChan handle chan "Hello. My name is fischbot. I am just like the other fischbot you all know and love, except I am written in Haskell. Flyingfisch is my author, and you can obtain help by typing !help"

infoBugs handle chan _ = writeToChan handle chan "You can report bugs on my GitHub page: https://github.com/flyingfisch/haskell-fischbot/issues"

infoContrib handle chan _ = writeToChan handle chan "You can fork me on GitHub: https://github.com/flyingfisch/haskell-fischbot"

sendVersion handle chan _ = writeToChan handle chan version
