class Stack<T> {
  final container = <T>[];
  void push(T thing) {
    container.add(thing);
  }

  T pop() => container.removeLast();

  @override
  String toString() =>
      container.map((element) => element.toString()).toList().toString();
}

final numDiscs = 3;
var towerA = Stack<int>();
var towerB = Stack<int>();
var towerC = Stack<int>();

void hanoi(
    {required Stack<int> from,
    required Stack<int> to,
    required Stack<int> temp,
    required int n}) {
  if (n == 1) {
    // base case
    to.push(from.pop()); // move 1 disk
  } else {
    // recursive case
    hanoi(from: from, to: temp, temp: to, n: n - 1);
    hanoi(from: from, to: to, temp: temp, n: 1);
    hanoi(from: temp, to: to, temp: from, n: n - 1);
  }
}
