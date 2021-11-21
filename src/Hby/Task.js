// task 其实是一个输入为空的函数里包着一个 promise

exports._map = (fun) => (task) => {
  return () => task().then(fun);
};
exports._apply = (task_fun) => (task) => {
  return () => task().then(task_fun());
};
exports._pure = (a) => () => {
  return new Promise((res, rej) => {
    res(a);
  });
};
exports._bind = (task) => (fun) => {
  return () => task().then((a) => fun(a)());
};

exports.liftEff = (eff) => {
  return (a) => {
    return () => {
      return new Promise((res, rej) => {
        res(eff(a)());
      });
    };
  };
};

exports.runTask = (task) => (fun) => () => {
  task().then(fun);
};
exports.runTask_ = (task) => () => {
  task();
};

exports.delay = (n) => () => {
  return new Promise((res, rej) => {
    setTimeout(() => {
      res();
    }, n);
  });
};
