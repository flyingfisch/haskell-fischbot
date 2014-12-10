module App.Commands
( commandList
) where

import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Data.Maybe
import System.Time

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
    ("!intro", intro),
    ("!ret", ret),
    ("!slap", slap),
    ("!say", say),
    ("!tell", tell),
    ("test", test),
    ("!uptime", uptime),
    ("!version", version'),
    ("!vars", showVars),
    ("!quit", quit)
    ]

addAdmin identline argument vars = do
    adminFile <- asks adminFn
    let (ident:_) = words argument
        username = extractUsername identline

    r <- isAdmin adminFile username

    if r
      then do
          appendAdmin adminFile ident
          privmsg ("Successfully added " ++ ident ++ " to admin list")
      else
          privmsg $ "Just what do you think you are doing, " ++ (splitOn "@" username !! 0) ++ "?"

    return $ junkVar vars

removeAdmin identline argument vars = do
    adminFile <- asks adminFn
    let (ident:_) = words argument
        username = extractUsername identline

    r <- isAdmin adminFile username

    if r
      then do
          deleteAdmin "./config/admins.txt" ident
          privmsg ("Successfully removed " ++ ident ++ " from admin list")
      else
          privmsg $ "Just what do you think you are doing, " ++ (splitOn "@" username !! 0) ++ "?"

    return $ junkVar vars

admins _ _ vars = do
    adminFile <- asks adminFn
    admins <- getAdmins adminFile
    let admins' = intercalate ", " admins
    privmsg admins'
    return $ junkVar vars

credits _ _ vars = do
    privmsg creditText
    return $ junkVar vars

help _ _ vars = do
    privmsg helpText
    privmsg helpText2
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

intro _ ("") vars = do
    privmsg "AAAAAAAAAAAAAAAAAAAH!!! YOU DIDN'T TELL ME WHO TO INTRODUCE!!!!"
    action "screams and yells and faints."
    return $ junkVar vars
intro _ name vars = do
    privmsg $ name ++ ", you should introduce yourself: http://community.casiocalc.org/topic/5677-introduce-yourself"
    return $ junkVar vars

ret ident _ vars = do
    let queue = read (getVar "[(\"\",\"\")]" "messages" vars) :: [(String, String)]
        (_:receiver) = head $ splitOn "!" ident
        messages = [x | (y,x) <- queue, y == receiver]

    if messages /= []
      then do
          privmsg $ receiver ++ ", here are some messages that were sent to you while you were offline:"
          mapM_ privmsg messages
          let newQueue = [(y,x) | (y,x) <- queue, y /= receiver]
          return $ updateVar "messages" (show newQueue) vars
      else do
          privmsg $ receiver ++ ": Sorry, couldn't find any messages for you."
          return $ junkVar vars



slap _ ("") vars = do
    privmsg "slap who?"
    return $ junkVar vars
slap _ name vars = do
    action ("slaps " ++ name ++ " with a giant fisch")
    return $ junkVar vars

say _ message vars = do
    privmsg message
    return $ junkVar vars

showVars _ _ vars = do
    privmsg $ show vars
    return $ junkVar vars

test _ _ vars = do
    let num = getVar "0" "test" vars
    privmsg ("Test Received " ++ num)
    return $ updateVar "test" (show ((read num) + 1)) vars

tell ident line vars = do
    if (length $ words line) > 1
      then do
          let (_:sender) = head (splitOn "!" ident)
              (sendTo:message) = words line
              queue = read (getVar "[(\"\",\"\")]" "messages" vars) :: [(String, String)]

          privmsg $ sender ++ ": OK, I'll let " ++ sendTo ++ " know about that when he gets back."

          let messageTuple = (sendTo, "From " ++ sender ++ ": " ++ (unwords message))
              newQueue = messageTuple:queue

          return $ updateVar "messages" (show newQueue) vars
      else do
          privmsg "Umm, don't you want me to tell him anything?"
          return $ junkVar vars

uptime _ message vars = do
    now <- io getClockTime
    zero <- asks startTime
    let raw = diffClockTimes now zero
    privmsg $ timeDiffToString $ raw
    return $ junkVar vars

version' _ _ vars = do
    v <- asks version
    privmsg v
    return $ junkVar vars

quit identline message vars = do
    adminFile <- asks adminFn
    let username = extractUsername identline

    r <- isAdmin adminFile username

    if r
      then do
          write "QUIT" ":My arm is tired, no more PING PONG"
          return $ updateVar "_quit" "set" vars
      else do
          privmsg ((splitOn "@" username !! 0) ++ ": HOW DARE YOU TRY TO TURN ME OFF!")
          return $ junkVar vars

