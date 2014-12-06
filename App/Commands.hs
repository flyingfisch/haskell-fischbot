module App.Commands
( commandList
) where

import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Data.Maybe

import App.Data
import App.Functions
import Irc.Write

-- functions are of type: f identAndStuff message vars
commandList :: [(String, (String -> String -> [(String, String)] -> Net [(String, String)]) )]
commandList = [
    ("!add-admin", addAdmin),
    ("!remove-admin", removeAdmin),
    ("!admins", admins),
    ("!credits", credits),
    ("!help", help),
    ("!info", info),
    ("!info-bugs", infoBugs),
    ("!info-contrib", infoContrib),
    ("test", test),
    ("!slap", slap),
    ("!say", say),
    ("!quit", quit)
    ]

addAdmin identline argument vars = do
    let (ident:_) = words argument
        username = extractUsername identline

    r <- isAdmin "./config/admins.txt" username

    if r
      then do
          appendAdmin "./config/admins.txt" ident
          privmsg ("Successfully added " ++ ident ++ " to admin list")
      else
          privmsg $ "Just what do you think you are doing, " ++ (splitOn "@" username !! 0) ++ "?"

    return $ junkVar vars

removeAdmin identline argument vars = do
    let (ident:_) = words argument
        username = extractUsername identline

    r <- isAdmin "./config/admins.txt" username

    if r
      then do
          deleteAdmin "./config/admins.txt" ident
          privmsg ("Successfully removed " ++ ident ++ " from admin list")
      else
          privmsg $ "Just what do you think you are doing, " ++ (splitOn "@" username !! 0) ++ "?"

    return $ junkVar vars

admins _ _ vars = do
    admins <- getAdmins "./config/admins.txt"
    let admins' = intercalate ", " admins
    privmsg admins'
    return $ junkVar vars

credits _ _ vars = do
    privmsg creditText
    return $ junkVar vars

help _ _ vars = do
    privmsg helpText
    return $ junkVar vars

info _ _ vars = do
    privmsg infoText
    return $ junkVar vars

infoBugs _ _ vars = do
    privmsg $ "You can report bugs at: " ++ gitHubRepo ++ "issues"
    return $ junkVar vars

infoContrib _ _ vars = do
    privmsg $ "Know Haskell? Fork me! " ++ gitHubRepo
    return $ junkVar vars

test _ _ vars = do
    let num = getVar "0" "test" vars
    privmsg ("Test Received " ++ num)
    return $ updateVar "test" (show ((read num) + 1)) vars

slap _ ("") vars = do
    privmsg "slap who?"
    return $ junkVar vars
slap _ name vars = do
    action ("slaps " ++ name ++ " with a giant fisch")
    return $ junkVar vars

say _ message vars = do
    privmsg message
    return $ junkVar vars

quit identline message vars = do
    let username = extractUsername identline

    r <- isAdmin "./config/admins.txt" username

    if r
      then do
          write "QUIT" ":My arm is tired, no more PING PONG"
          return $ updateVar "_quit" "set" vars
      else do
          privmsg ((splitOn "@" username !! 0) ++ ": HOW DARE YOU TRY TO TURN ME OFF!")
          return $ junkVar vars

