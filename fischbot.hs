import Control.Monad
import Control.Monad.Reader
import Data.List
import Data.List.Split
import Network
import System.IO
import System.Environment

import Irc.Write
import Irc.Listen

type Net = ReaderT Bot IO
data Bot = Bot { socket :: Handle }


server = "irc.afternet.org"
port = 6667
chan = "#fischbot"
nick = "hFischbot"

main = do
    --args <- getArgs
    --handleArgs args
    fischbotGlobals <- connect

    runReaderT sendNick fischbotGlobals

{-    waitForMOTD handle

    write handle "JOIN" chan

    listen handle
-}

connect :: IO Bot
connect = do
    putStrLn "Connecting..."
    handle <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering handle NoBuffering
    return $ Bot handle

sendNick :: Handle -> IO ()
sendNick handle = do
    write "NICK" nick
    write "USER" (nick ++ " 0 * :haskell-fischbot")


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

