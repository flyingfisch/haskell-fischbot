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

    newVars <- commandHandler handle (words line) vars

    listen handle newVars

pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

commandHandler :: Handle -> [String] -> [(String, String)] -> Net [(String, String)]
commandHandler handle (ident:irccmd:chan':command:message) vars =
    case (lookup command commandList) of (Just action) -> action (unwords message) vars
                                         (_) -> return $ junkVar vars
commandHandler _ _ vars = return $ junkVar vars
