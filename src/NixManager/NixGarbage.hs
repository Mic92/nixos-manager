{-# LANGUAGE OverloadedStrings #-}
module NixManager.NixGarbage
  ( collectGarbage
  )
where

import           NixManager.AskPass             ( sudoExpr )
import           Data.Text                      ( Text )
import           Data.Text.Encoding             ( encodeUtf8 )
import           NixManager.Util                ( mwhen )
import           NixManager.BashDsl             ( Expr(Command) )
import           Prelude                 hiding ( readFile )
import           NixManager.Process             ( runProcess
                                                , ProcessData
                                                )

collectGarbageExpr :: Bool -> Expr
collectGarbageExpr olderGenerations =
  Command "nix-collect-garbage" (mwhen olderGenerations ["-d"])

collectGarbage :: Bool -> Text -> IO ProcessData
collectGarbage olderGenerations password = runProcess
  (Just (encodeUtf8 password))
  (sudoExpr (collectGarbageExpr olderGenerations))

