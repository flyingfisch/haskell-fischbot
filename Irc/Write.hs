module Irc.Write
( write
, writeToChan
) where

import Control.Monad
import Data.List
import Network
import System.IO
import Text.Printf

write :: Handle -> String -> String -> IO ()
write handle command args = do
    hPrintf handle "%s %s\r\n" command args
    printf "-> %s %s\n" command args

writeToChan :: Handle -> String -> String -> IO ()
writeToChan handle chan message = write handle ("PRIVMSG " ++ chan) (':':message)

