// task 其实是一个输入为空的函数里包着一个 promise

// 辅助
function getError(e) {
  if (
    e instanceof Error ||
    Object.prototype.toString.call(e) === "[object Error]"
  ) {
    return e;
  } else {
    return new Error(e.toString());
  }
}

// 函子-应用函子-单子
exports._map = (fun) => (task) => {
  return () => task().then(fun);
};
exports._apply = (task_fun) => (task) => {
  return () =>
    task_fun().then((f) => {
      return task().then((v) => {
        return f(v);
      });
    });
};
exports._pure = (a) => () => {
  return new Promise((res, rej) => {
    res(a);
  });
};
exports._bind = (task) => (fun) => {
  return () => {
    return task().then((a) => fun(a)());
  };
};

// alt-plus
exports._alt = (t1) => (t2) => {
  return () =>
    new Promise((res, rej) => {
      t1()
        .then((a) => res(a))
        .catch((_) =>
          t2()
            .then((a) => res(a))
            .catch((e) => rej(getError(e)))
        );
    });
};
exports._empty = () => {
  return new Promise((res, rej) => {
    rej(getError("_empty"));
  });
};

// 兼容
exports._liftEffect = (eff) => () => {
  return new Promise((res, rej) => {
    res(eff());
  });
};

// run
exports.runTask = (task) => (fun) => () => {
  return task().then((a) => fun(a)());
};
exports.runTask_ = (task) => () => {
  task();
};

// 错误处理
exports._throwException = function (e) {
  return () =>
    new Promise((res, rej) => {
      rej(getError(e));
    });
};
exports._catchException = (l) => (r) => (task) => {
  return () =>
    new Promise((res, rej) => {
      task()
        .then((a) => res(r(a)))
        .catch((e) => res(l(getError(e))));
    });
};

// mkTask :: forall a. ((a -> Effect Unit) -> (String -> Effect Unit) -> Effect Unit) -> Task a
exports.mkTask = (f) => () => {
  return new Promise((res, rej) => {
    f((a) => () => res(a))((a) => () => rej(a))();
  });
};

// unsafeRunTask :: forall a. Task a -> Unit
exports.unsafeRunTask = (t) => {
  t();
};

// lazy :: forall a b. (a -> Task b) -> (a -> Task b)
exports.lazy = (f) => (a) => {
  return () => f(a)()
}
