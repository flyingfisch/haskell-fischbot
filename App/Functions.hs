module App.Functions
( io
, removeByKey
, updateVar
, junkVar
, getVar
, getAdmins
, isAdmin
, extractUsername
, appendAdmin
, deleteAdmin
) where

import Control.Monad.Reader
import Data.List.Split
import Data.Maybe
import System.Directory
import System.IO

import App.Data

io :: IO a -> Net a
io = liftIO

removeByKey :: String -> [(String, String)] -> [(String, String)]
removeByKey key l = [(k,v) | (k,v) <- l, k /= key]

updateVar :: String -> String -> [(String, String)] -> [(String, String)]
updateVar key value list = [(key, value)] ++ (removeByKey key list)

junkVar :: [(String, String)] -> [(String, String)]
junkVar list = updateVar "" "" list

getVar :: String -> String -> [(String, String)] -> String
getVar d k l = fromMaybe d $ lookup k l

getAdmins :: String -> Net [String]
getAdmins fileName = do
    admins <- io $ readFile fileName
    return $ lines admins

isAdmin :: String -> String -> Net Bool
isAdmin fileName username = do
    admins <- getAdmins fileName
    if (username `elem` admins)
      then return True
      else return False

appendAdmin :: String -> String -> Net ()
appendAdmin fileName username = io $ do
    handle <- openFile fileName ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle
    hPutStr tempHandle (contents ++ username ++ "\n")
    hClose handle
    hClose tempHandle
    removeFile fileName
    renameFile tempName fileName

deleteAdmin :: String -> String -> Net ()
deleteAdmin fileName username = io $ do
    handle <- openFile fileName ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle
    let newContents = [x | x <- (lines contents), x /= username]
    hPutStr tempHandle (unlines newContents)
    hClose handle
    hClose tempHandle
    removeFile fileName
    renameFile tempName fileName

extractUsername :: String -> String
extractUsername identline = splitOn "!" ((words identline) !! 0) !! 1
