module App.Commands
( commandList
, test
) where

import Control.Monad
import Control.Monad.Reader
import Data.Maybe

import App.Data
import App.Functions
import Irc.Write

-- functions are of type: f line vars
commandList :: [(String, (String -> [(String, String)] -> Net [(String, String)]) )]
commandList = [
    (":test", test)
    ]

test _ vars = do
    chan <- asks chan
    let num = getVar "0" "test" vars
    privmsg chan ("Test Received " ++ num)
    return $ updateVar "test" (show ((read num) + 1)) vars


