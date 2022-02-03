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

exports.liftEffect = (eff) => () => {
  return new Promise((res, rej) => {
    res(eff());
  });
};

exports.runTask = (task) => (fun) => () => {
  return task().then((a) => fun(a)());
};
exports.runTask_ = (task) => () => {
  task();
};

exports._mempty = () => {
  return new Promise((res, rej) => {
    res();
  });
};

exports._alt = (t1) => (t2) => () => {
  return new Promise((res, rej) => {
    t1()
      .then((a) => res(a))
      .catch((_) => t2().then((a) => res(a)));
  });
};

exports._empty = () => {
  return new Promise((res, rej) => {
    rej();
  });
};
