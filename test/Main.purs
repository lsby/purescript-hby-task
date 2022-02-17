module Test.Main where

import Prelude
import Control.Alt ((<|>))
import Control.MonadPlus (empty)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (message)
import Effect.Timer (setTimeout)
import Hby.Task (Task, liftEffect, runTask, runTask_, throw, try, mkTask)
import OhYes (generateTS)
import Type.Proxy (Proxy(..))

test_runTask :: Effect Unit
test_runTask = runTask (pure "ok-test_runTask") (\a -> log a)

test_liftEffect_runTask_ :: Effect Unit
test_liftEffect_runTask_ =
  runTask_ do
    liftEffect $ log "ok-test_liftEffect_runTask_"

test_map :: Task Unit
test_map = do
  a <- map (\a -> a <> "k-test_map") (pure "o")
  liftEffect $ log a

test_apply :: Task Unit
test_apply = do
  a <- apply (pure $ \a -> a <> "k-test_apply") (pure "o")
  liftEffect $ log a

test_bind :: Task Unit
test_bind = do
  a <- bind (pure "o") (\a -> pure $ a <> "k-test_bind")
  liftEffect $ log a

test_append :: Task Unit
test_append = do
  a <- (pure $ "o") <> (pure $ "k") <> (pure $ "-test_append")
  liftEffect $ log a

test_mempty :: Task Unit
test_mempty = do
  a <- mempty <> (pure $ "ok-test_mempty")
  liftEffect $ log a

test_alt1 :: Task Unit
test_alt1 = do
  a <- pure "ok-test_alt1" <|> throw "err"
  liftEffect $ log a

test_alt2 :: Task Unit
test_alt2 = do
  a <- throw "err" <|> pure "ok-test_alt2"
  liftEffect $ log a

test_empty1 :: Task Unit
test_empty1 = do
  a <- empty <|> pure "ok-test_empty1"
  liftEffect $ log a

test_empty2 :: Task Unit
test_empty2 = do
  a <- pure "ok-test_empty2" <|> empty
  liftEffect $ log a

test_try :: Task Unit
test_try = do
  a <- try $ throw "err"
  case a of
    Left _ -> liftEffect $ log "ok-test_try"
    Right _ -> liftEffect $ log "err-test_try"

test_try_alt1 :: Task Unit
test_try_alt1 = do
  a <- try $ throw "err" <|> empty
  case a of
    Left x -> case message x of
      "_empty" -> liftEffect $ log "ok-test_try_alt1"
      _ -> liftEffect $ log "err-test_try_alt1"
    Right _ -> liftEffect $ log "err-test_try_alt1"

test_try_alt2 :: Task Unit
test_try_alt2 = do
  a <- try $ pure "ok" <|> pure "err"
  case a of
    Left _ -> liftEffect $ log "err-test_try_alt2"
    Right s -> liftEffect $ log $ s <> "-test_try_alt2"

type Test
  = Task String

test_generateTS :: Task Unit
test_generateTS = do
  liftEffect
    $ log case eq (generateTS "test" (Proxy :: Proxy Test)) ("export type test = () => Promise<string>") of
        true -> "ok-test_generateTS"
        false -> "err-test_generateTS"

test_mkTask1 :: Task Unit
test_mkTask1 =
  mkTask \res _ -> do
    _ <-
      setTimeout 1000 do
        log "ok-test_mkTask1"
        res unit
    pure unit

test_mkTask2 :: Task Unit
test_mkTask2 =
  mkTask \res _ -> do
    log "ok-test_mkTask2"
    res unit

main :: Effect Unit
main =
  runTask_ do
    -- run
    liftEffect $ test_runTask
    liftEffect $ test_liftEffect_runTask_
    -- mk
    test_mkTask1
    test_mkTask2
    -- Functor-Apply-Applicative-Bind
    test_map
    test_apply
    test_bind
    -- Semigroup
    test_append
    -- Monoid
    test_mempty
    -- Alt-Plus
    test_alt1
    test_alt2
    test_empty1
    test_empty2
    -- 错误处理
    test_try
    test_try_alt1
    test_try_alt2
    -- 允许生成ts类型
    test_generateTS
