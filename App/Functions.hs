module App.Functions
( io
) where

import Control.Monad.Reader

import App.Data

io :: IO a -> Net a
io = liftIO
