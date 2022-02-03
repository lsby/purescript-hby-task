module Hby.Task where

import Prelude
import Effect (Effect)

foreign import data Task :: Type -> Type

-------------------------
foreign import _map :: forall a b. (a -> b) -> Task a -> Task b

foreign import _apply :: forall a b. Task (a -> b) -> Task a -> Task b

foreign import _pure :: forall a. a -> Task a

foreign import _bind :: forall a b. Task a -> (a -> Task b) -> Task b

-------------------------
foreign import runTask :: forall a. Task a -> (a -> Unit) -> Effect Unit

foreign import runTask_ :: forall a. Task a -> Effect Unit

foreign import liftEff :: forall a b. (a -> Effect b) -> (a -> Task b)

foreign import delay :: Int -> Task Unit

-------------------------
instance mapTask :: Functor Task where
  map :: forall a b. (a -> b) -> Task a -> Task b
  map = _map

instance applyTask :: Apply Task where
  apply :: forall a b. Task (a -> b) -> Task a -> Task b
  apply = _apply

instance pureTask :: Applicative Task where
  pure :: forall a. a -> Task a
  pure = _pure

instance bindTask :: Bind Task where
  bind :: forall a b. Task a -> (a -> Task b) -> Task b
  bind = _bind

instance appendTask :: Semigroup a => Semigroup (Task a) where
  append :: Task a -> Task a -> Task a
  append a b = do
    aa <- a
    bb <- b
    pure $ aa <> bb
