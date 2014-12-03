import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Network
import System.IO
import System.Environment

import App.Data
import Irc.Write
import Irc.Listen


main = do
    --args <- getArgs
    --handleArgs args
    fischbotGlobals <- connect

    runReaderT sendNick fischbotGlobals

    runReaderT waitForMOTD fischbotGlobals

    runReaderT join fischbotGlobals

    runReaderT listen fischbotGlobals


connect :: IO Bot
connect = do
    putStrLn "Connecting..."
    handle <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering handle NoBuffering
    return $ Bot handle

sendNick :: IO ()
sendNick = do
    write "NICK" nick
    write "USER" (nick ++ " 0 * :haskell-fischbot")

join :: IO ()
join = do
    write "JOIN" chan


--handleArgs :: [String] -> [String]
--handleArgs args = 

{-handleArg :: String -> Maybe String
handleArg arg
    | argName !! 0 == "server" = ("server", argVal)
    | argName !! 0 == "port" = ("port", argVal)
    | argName !! 0 == "chan" = ("chan", argVal)
    | argName !! 0 == "nick" = ("nick", argVal)
    | otherwise = Nothing
    where argName = (splitOn "=" arg) !! 0
          argVal = (splitOn "=" arg) !! 1-}

