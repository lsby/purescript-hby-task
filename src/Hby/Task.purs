module Hby.Task where

import Prelude
import Control.Alt (class Alt)
import Control.Plus (class Plus)
import Effect (Effect)

foreign import data Task :: Type -> Type

-------------------------
-- js 映射
-------------------------
foreign import _map :: forall a b. (a -> b) -> Task a -> Task b

foreign import _apply :: forall a b. Task (a -> b) -> Task a -> Task b

foreign import _pure :: forall a. a -> Task a

foreign import _bind :: forall a b. Task a -> (a -> Task b) -> Task b

foreign import _mempty :: forall a. Task a

foreign import _alt :: forall a. Task a -> Task a -> Task a

foreign import _empty :: forall a. Task a

-------------------------
-- 函数
-------------------------
foreign import runTask :: forall a. Task a -> (a -> Effect Unit) -> Effect Unit

foreign import runTask_ :: forall a. Task a -> Effect Unit

foreign import liftEffect :: forall a. Effect a -> Task a

-------------------------
-- 类型类实现
-------------------------
instance taskFunctor :: Functor Task where
  map :: forall a b. (a -> b) -> Task a -> Task b
  map = _map

instance taskApply :: Apply Task where
  apply :: forall a b. Task (a -> b) -> Task a -> Task b
  apply = _apply

instance taskApplicative :: Applicative Task where
  pure :: forall a. a -> Task a
  pure = _pure

instance taskBind :: Bind Task where
  bind :: forall a b. Task a -> (a -> Task b) -> Task b
  bind = _bind

instance taskSemigroup :: Semigroup a => Semigroup (Task a) where
  append :: Task a -> Task a -> Task a
  append a b = do
    aa <- a
    bb <- b
    pure $ aa <> bb

instance taskMonoid :: Semigroup (Task a) => Monoid (Task a) where
  mempty :: Task a
  mempty = _mempty

instance taskAlt :: Functor Task => Alt Task where
  alt :: forall a. Task a -> Task a -> Task a
  alt = _alt

instance taskPlus :: Alt Task => Plus Task where
  empty :: forall a. Task a
  empty = _empty
