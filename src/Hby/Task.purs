module Hby.Task where

import Prelude
import Control.Alt (class Alt)
import Control.Plus (class Plus)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, message, runAff)
import Effect.Console (log) as E
import Effect.Exception (Error, error)
import HasJSRep (class HasJSRep)
import OhYes (class HasTSRep, toTSRep)
import Type.Proxy (Proxy(..))

-------------------------
-- 数据类型
-------------------------
foreign import data Task :: Type -> Type

foreign import data Promise :: Type

-------------------------
-- js 映射
-------------------------
foreign import _map :: forall a b. (a -> b) -> Task a -> Task b

foreign import _apply :: forall a b. Task (a -> b) -> Task a -> Task b

foreign import _pure :: forall a. a -> Task a

foreign import _bind :: forall a b. Task a -> (a -> Task b) -> Task b

foreign import _alt :: forall a. Task a -> Task a -> Task a

foreign import _empty :: forall a. Task a

foreign import _throwException :: forall a. Error -> Task a

foreign import _catchException ::
  forall a.
  (Error -> Either Error a) ->
  (a -> Either Error a) ->
  Task a -> Task (Either Error a)

-------------------------
-- 函数
-------------------------
foreign import runTask :: forall a. Task a -> (a -> Effect Unit) -> Effect Unit

foreign import runTask_ :: forall a. Task a -> Effect Unit

foreign import liftEffect :: forall a. Effect a -> Task a

foreign import mkTask :: forall a. ((a -> Effect Unit) -> (String -> Effect Unit) -> Effect Unit) -> Task a

foreign import unsafeRunTask :: forall a. Task a -> Promise

foreign import lazy :: forall a b. (a -> Task b) -> (a -> Task b)

throw :: forall a. String -> Task a
throw = _throwException <<< error

try :: forall a. Task a -> Task (Either Error a)
try action = _catchException Left Right action

log :: String -> Task Unit
log s = liftEffect $ E.log s

aff2task :: forall a. Aff a -> Task a
aff2task aff =
  mkTask \res rej -> do
    _ <-
      runAff
        ( \e -> case e of
            Left err -> rej $ message err
            Right d -> res d
        )
        aff
    pure unit

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

instance taskMonoid :: Monoid a => Monoid (Task a) where
  mempty :: Task a
  mempty = _pure mempty

instance taskAlt :: Alt Task where
  alt :: forall a. Task a -> Task a -> Task a
  alt = _alt

instance taskPlus :: Plus Task where
  empty :: forall a. Task a
  empty = _empty

instance taskHasJSRep :: HasJSRep a => HasJSRep (Task a)

instance taskHasTSRep :: HasTSRep a => HasTSRep (Task a) where
  toTSRep _ = "() => Promise<" <> toTSRep ((Proxy :: Proxy a)) <> ">"
