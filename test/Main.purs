module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Class.Console (log)
import Hby.Prmoise (delay, liftEff, runTask_)

main :: Effect Unit
main =
  runTask_ do
    delay 1000
    liftEff log "123"
