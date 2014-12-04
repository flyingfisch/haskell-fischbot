module Irc.Write
( write
, privmsg
, action
) where

import Control.Monad.Reader
import Network
import Text.Printf

import App.Data
import App.Functions

write :: String -> String -> Net ()
write command arg = do
    handle <- asks socket
    io $ hPrintf handle "%s %s\r\n" command arg
    io $ printf "-> %s %s\n" command arg

privmsg :: String -> String -> Net ()
privmsg chan message = write "PRIVMSG" (chan ++ " :" ++ message)

action :: String -> String -> Net ()
action chan message = privmsg chan ("\SOHACTION " ++ message ++ "\SOH")
