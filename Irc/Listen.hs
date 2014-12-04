module Irc.Listen
( listen
, motdHandler
) where

import Control.Monad
import Network
import System.IO
import Text.Printf

import App.Commands
import App.Data
import App.Functions
import Irc.Write

motdHandler :: Handle -> Net ()
motdHandler handle = do
    line <- io $ hGetLine handle
    io $ printf "<- (Awaiting MOTD) %s\n" line

    pongHandler handle line

    if (words line !! 1 == "376")
      then do
          io $ putStrLn "MOTD RECEIVED"
          return ()
      else do
          motdHandler handle

listen :: Handle -> [(String, String)] -> Net ()
listen handle vars = do
    line <- io (hGetLine handle)
    io $ printf "<- %s\n" line

    pongHandler handle line

    commandHandler handle (words line) vars

    listen handle vars

pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

commandHandler :: Handle -> [String] -> [(String, String)] -> Net [(String, String)]
commandHandler handle (ident:command:chan':message) vars = if (":test" == (unwords message))
                                                            then test message vars
                                                            else return $ [("", "")] ++ vars
commandHandler _ _ vars = return $ [("", "")] ++ vars
