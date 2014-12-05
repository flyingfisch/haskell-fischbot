module App.Commands
( commandList
) where

import Control.Monad
import Control.Monad.Reader
import Data.Maybe

import App.Data
import App.Functions
import Irc.Write

-- functions are of type: f message vars
commandList :: [(String, (String -> [(String, String)] -> Net [(String, String)]) )]
commandList = [
    (":!credits", credits),
    (":!help", help),
    (":!info", info),
    (":!info-bugs", infoBugs),
    (":!info-contrib", infoContrib),
    (":test", test),
    (":!slap", slap),
    (":!say", say)
    ]

credits _ vars = do
    privmsg creditText
    return $ junkVar vars

help _ vars = do
    privmsg helpText
    return $ junkVar vars

info _ vars = do
    privmsg infoText
    return $ junkVar vars

infoBugs _ vars = do
    privmsg $ "You can report bugs at: " ++ gitHubRepo ++ "issues"
    return $ junkVar vars

infoContrib _ vars = do
    privmsg $ "Know Haskell? Fork me! " ++ gitHubRepo
    return $ junkVar vars

test _ vars = do
    let num = getVar "0" "test" vars
    privmsg ("Test Received " ++ num)
    return $ updateVar "test" (show ((read num) + 1)) vars

slap ("") vars = do
    privmsg "slap who?"
    return $ junkVar vars
slap name vars = do
    action ("slaps " ++ name ++ " with a giant fisch")
    return $ junkVar vars

say message vars = do
    privmsg message
    return $ junkVar vars
