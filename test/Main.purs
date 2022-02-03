module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Hby.Task (Task, liftEffect, runTask, runTask_)

test_runTask :: Effect Unit
test_runTask = runTask (pure "ok") (\a -> log a)

test_liftEffect_runTask_ :: Effect Unit
test_liftEffect_runTask_ =
  runTask_ do
    liftEffect $ log "ok"

test_map :: Task Unit
test_map = do
  b <- map (\a -> a + 1) (pure 1)
  case b of
    2 -> liftEffect $ log "ok"
    _ -> liftEffect $ log "err"

main :: Effect Unit
main =
  runTask_ do
    liftEffect $ test_runTask
    liftEffect $ test_liftEffect_runTask_
    test_map
