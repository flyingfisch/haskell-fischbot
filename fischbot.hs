import Control.Exception
import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Data.Maybe
import Network
import System.IO
import System.Environment

import App.Data
import App.Functions
import Irc.Write
import Irc.Listen

versionString = "0.1 beta"
adminFile = "./config/admins.txt"

main :: IO ()
main = do
    -- take care of the command line args first
    args <- getArgs
    let argList = argsHandler args
    let server = fromMaybe "irc.afternet.org" (lookup "--server" (argList))
    let port = fromMaybe "6667" (lookup "--port" (argList))
    let chan = fromMaybe "#fischbot" (lookup "--chan" (argList))
    let nick = fromMaybe "hFischbot" (lookup "--nick" (argList))
    let helpFlag = fromMaybe "notset" (lookup "--help" (argList))

    if helpFlag == "notset"
      then bracket (connect server port chan nick) disconnect loop
      else help

    where
    disconnect = hClose . socket
    loop globals = runReaderT run globals

connect :: String -> String -> String -> String -> IO Bot
connect server port chan nick = do
    -- open a socket
    handle <- connectTo server (PortNumber (fromIntegral (read port)))
    hSetBuffering handle NoBuffering

    -- return the Bot class with our handle so other functions can use it
    return $ Bot handle server port chan nick adminFile versionString


run :: Net ()
run = do
    server <- asks server
    port <- asks port
    chan <- asks chan
    nick <- asks nick

    -- tell the server our nickname
    write "NICK" nick
    write "USER" (nick ++ " 0 * :haskell-fischbot")

    -- run motdHandler, which takes a Handle so we send it one with ReaderT
    asks socket >>= motdHandler

    -- OK, we have the MOTD, so now let's join
    write "JOIN" chan

    -- listen, and remember we still need to send that handle!
    handle <- asks socket
    listen handle [("", "")]

    -- make the result Net ()
    return ()

argsHandler :: [String] -> [(String, String)]
argsHandler args = map (argHandler . splitOn "=") args

argHandler :: [String] -> (String, String)
argHandler (arg:[value]) = case arg of "--server" -> (arg, value)
                                       "--port" -> (arg, value)
                                       "--nick" -> (arg, value)
                                       "--chan" -> (arg, value)
                                       (_) -> ("", "")
argHandler (["--help"]) = ("--help", "set")
argHandler (_) = ("", "")

help :: IO ()
help = putStrLn "Usage: fischbot [OPTIONS]\n\nArguments:\n--server=servername: server (defaults to irc.afternet.org)\n--port=portNumber: port number, defaults to 6667\n--nick=nickname: nickname for fischbot to use, defaults to hFischbot\n--chan=#channel: channel to connect to, remember to supply the pound sign"
