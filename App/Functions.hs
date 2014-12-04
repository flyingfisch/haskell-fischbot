module App.Functions
( io
, removeByKey
, updateVar
, junkVar
, getVar
) where

import Control.Monad.Reader
import Data.Maybe

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
