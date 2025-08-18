// fibonacci

int fib2(int n) {
  assert(n >= 0);
  if (n < 2) {
    return n;
  }
  return fib2(n - 1) + fib2(n - 2);
}

// memoization
var fibMemo = {0: 0, 1: 1};

int fib3(int n) {
  assert(n >= 0);
  var result = fibMemo[n];
  if (result != null) {
    return result;
  }
  fibMemo[n] = fib3(n - 1) + fib3(n - 2);
  return fibMemo[n]!;
}

// iterative approach
int fib4(int n) {
  if (n == 0) {
    return n;
  }
  var last = 0;
  var next = 1;
  for (var i = 1; i < n; i++) {
    (last, next) = (next, last + next);
  }
  return next;
}
