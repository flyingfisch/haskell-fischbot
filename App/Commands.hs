module App.Commands
( commandList
, test
) where

import Control.Monad
import Control.Monad.Reader

import App.Data
import Irc.Write

-- functions are of type: f line vars
commandList :: [(String, (String -> [(String, String)] -> Net [(String, String)]) )]
commandList = [
    ("test", test)
    ]

test _ vars = do
    chan <- asks chan
    privmsg chan "Test Received"
    return $ [("","")] ++ vars

