module Irc.Listen
( listen
, motdHandler
) where

import Data.List.Split
import Control.Monad
import Control.Monad.Reader
import Network
import System.Exit
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
    let _quit = getVar "unset" "_quit" newVars
    if _quit == "set" then io $ exitWith ExitSuccess else return ()

    listen handle newVars

pongHandler :: Handle -> String -> Net ()
pongHandler handle line = do
    if words line  !! 0 == "PING"
      then write "PONG" (words line !! 1)
      else return ()

commandHandler :: Handle -> [String] -> [(String, String)] -> Net [(String, String)]
commandHandler handle (ident:irccmd:from:(_:command):message) vars =
    case (lookup command commandList) of (Just action) -> action (unwords ([ident,irccmd,from])) (unwords message) vars
                                         (_) -> return $ junkVar vars

commandHandler handle ((_:ident):"JOIN":xs) vars = do
    adminFile <- asks adminFn
    chan <- asks chan
    r <- isAdmin adminFile (extractUsername ident)

    if r then write "MODE" (chan ++ " +o " ++ (head $ splitOn "!" ident)) else return ()
    -- return messages
    fischbotnick <- asks nick
    if (head $ splitOn "!" ident) /= fischbotnick
      then
        returnMessages (":" ++ ident) True vars
      else
        return $ junkVar vars


commandHandler _ _ vars = return $ junkVar vars
