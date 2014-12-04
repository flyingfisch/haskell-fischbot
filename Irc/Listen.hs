module Irc.Listen
( listen
, motdHandler
) where

import Network
import System.IO
import Text.Printf

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

listen :: Handle -> Net ()
listen handle = do
    line <- io (hGetContents handle)
    io $ putStrLn line

pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

