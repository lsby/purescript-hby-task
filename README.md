# hby-task

## 使用

```
in  upstream
  with hby-task =
      { dependencies =
            [ "console"
            , "control"
            , "effect"
            , "either"
            , "exceptions"
            , "has-js-rep"
            , "ohyes"
            , "prelude"
            , "psci-support"
            ]
      , repo =
          "https://github.com/lsby/purescript-hby-task"
      , version =
          "v0.0.7"
      }
  with ohyes =
      { dependencies =
            [ "aff"
            , "effect"
            , "foldable-traversable"
            , "functions"
            , "has-js-rep"
            , "lists"
            , "node-buffer"
            , "node-fs"
            , "nullable"
            , "prelude"
            , "prettier"
            , "psci-support"
            , "spec"
            , "typelevel-prelude"
            , "variant"
            ]
      , repo =
          "https://github.com/lsby/purescript-ohyes"
      , version =
          "ls-v1.0.1"
      }
  with has-js-rep =
      { dependencies =
            [ "aff-promise"
            , "arrays"
            , "console"
            , "effect"
            , "foldable-traversable"
            , "foreign-object"
            , "functions"
            , "nullable"
            , "prelude"
            , "psci-support"
            , "record-format"
            , "strings"
            , "typelevel-prelude"
            , "variant"
            ]
      , repo =
          "https://github.com/lsby/purescript-has-js-rep"
      , version =
          "ls-v1.0.0"
      }
  with record-format =
      { dependencies =
            [ "assert"
            , "effect"
            , "prelude"
            , "psci-support"
            , "record"
            , "typelevel-prelude"
            ]
      , repo =
          "https://github.com/lsby/purescript-record-format"
      , version =
          "ls-v1.0.0"
      }
```

```
spago install hby-task
```
