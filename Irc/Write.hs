module Irc.Write
( write
, writeToChan
, writeToChanMe
) where

import Control.Monad
import Control.Monad.Reader
import Data.List
import Network
import System.IO
import Text.Printf

import App.Data

write :: String -> String -> Net ()
write command args = do
    handle <- asks socket
    io $ hPrintf handle "%s %s\r\n" command args
    io $ printf "-> %s %s\n" command args

writeToChan :: String -> String -> Net ()
writeToChan chan message = write ("PRIVMSG " ++ chan) (':':message)

writeToChanMe :: String -> String -> Net ()
writeToChanMe chan message = write ("PRIVMSG " ++ chan) (":\SOHACTION " ++ message ++ "\SOH")

io :: IO a -> Net a
io = liftIO
