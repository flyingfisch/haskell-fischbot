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

write :: Handle -> String -> String -> IO ()
write command args = do
    handle <- asks socket
    hPrintf handle "%s %s\r\n" command args
    printf "-> %s %s\n" command args

writeToChan :: Handle -> String -> String -> IO ()
writeToChan handle chan message = write handle ("PRIVMSG " ++ chan) (':':message)

writeToChanMe :: Handle -> String -> String -> IO ()
writeToChanMe handle chan message = write handle ("PRIVMSG " ++ chan) (":\SOHACTION " ++ message ++ "\SOH")
