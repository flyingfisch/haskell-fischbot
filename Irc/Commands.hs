module Irc.Commands
( handleCommands
) where

import Control.Monad
import Control.Monad.Reader
import Data.List
import Network
import System.IO
import Text.Printf

import App.Data
import Irc.Write

-- version
versionString = "0.1b"

-- Command set list and function to handle commands
commandSet :: [(String, String -> String -> [String] -> Net ())]
commandSet =
    [
        (":!info", info),
        (":!info-bugs", infoBugs),
        (":!info-contrib", infoContrib),
        (":!intro", intro),
        (":test", test),
        (":!say", say),
        (":!slap", slap),
        (":!version", version)
    ]

handleCommands :: [String] -> Net ()
handleCommands (ident:irccmd:chan:command:message) = do
    case (lookup command commandSet) of (Just action) -> action chan (unwords message) [ident, irccmd]
                                        (_) -> return ()
handleCommands (_) = return ()

-- Commands
intro chan "" _ = writeToChan chan "You didn't tell me who to introduce!"
intro chan name _ = writeToChan chan (name ++ ", You should introduce yourself: http://community.casiocalc.org/topic/5677-introduce-yourself")

info chan _ _ = writeToChan chan "Hello. My name is fischbot. I am just like the other fischbot you all know and love, except I am written in Haskell. Flyingfisch is my author, and you can obtain help by typing !help"

infoBugs chan _ _ = writeToChan chan "You can report bugs on my GitHub page: https://github.com/flyingfisch/haskell-fischbot/issues"

infoContrib chan _ _ = writeToChan chan "You can fork me on GitHub: https://github.com/flyingfisch/haskell-fischbot"

say chan message _ = writeToChan chan message

slap chan "" _ = writeToChan chan "Who shall I slap?"
slap chan name _ = writeToChanMe chan ("slaps " ++ name ++ " around with a large fisch.")

test chan _ _ = writeToChan chan "Test received."

version chan _ _ = writeToChan chan ("Haskell-Fischbot version: " ++ versionString)
