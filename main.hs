{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<$>))
import qualified Data.ByteString.Char8 as BS
import Network.HTTP.Conduit (Request, Response(..), httpLbs, parseUrl, urlEncodedBody, withManager)
import System.Environment (getArgs)

import Network.Hiphask

hipchatUrl :: String
hipchatUrl = "https://api.hipchat.com/v1/rooms/message?room_id=65466&from=Sam+playing&message_format=text"

authedHipchatUrl :: String -> String
authedHipchatUrl token = hipchatUrl ++ "&auth_token=" ++ token

notifyRequest :: Monad m => String -> String -> IO (Request m)
notifyRequest token message = urlEncodedBody [("message", BS.pack message)] <$> parseUrl (authedHipchatUrl token)

main :: IO ()
main = do
  [token] <- getArgs
  message <- getContents
  request <- notifyRequest token message
  print =<< withManager (httpLbs request)
