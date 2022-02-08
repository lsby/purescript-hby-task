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
            , "prelude"
            , "psci-support"
            ]
      , repo =
          "https://github.com/lsby/purescript-hby-task"
      , version =
          "v0.0.5"
      }
```

```
spago install hby-task
```
