import 'dart:math' as math;
import 'package:collection/collection.dart';

enum Cell implements Comparable<Cell> {
  empty(char: "E"),
  blocked(char: "B"),
  start(char: "S"),
  goal(char: "G"),
  path(char: "P");

  const Cell({required this.char});

  final String char;

  @override
  int compareTo(Cell other) => char.runes.first - other.char.runes.first;
}

typedef Maze = List<List<Cell>>;

Maze generateMaze({
  required int rows,
  required int cols,
  required double blockProbability,
}) {
  assert(
    rows > 0 && cols > 0 && blockProbability >= 0 && blockProbability <= 1,
    "rows and cols must be > 0, sparseness must be between 0 and 1 inclusive",
  );
  // NOTE wrong approach: all elements would be shared
  // final maze = List.filled(rows, List.filled(columns, Cell.empty));

  final maze = List.generate(
    rows,
    (_) => List.generate(cols, (_) => Cell.empty),
  );

  for (var row = 0; row < rows; row++) {
    for (var col = 0; col < cols; col++) {
      var rnd = math.Random().nextDouble();
      if (rnd < blockProbability) {
        maze[row][col] = Cell.blocked;
      }
    }
  }
  return maze;
}

void printMaze(Maze maze) {
  for (var i = 0; i < maze.length; i++) {
    print(maze[i].map((cell) => cell.char));
  }
}

class MazeLocation {
  int row;
  int col;

  MazeLocation({required this.row, required this.col});
  @override
  bool operator ==(Object other) =>
      other is MazeLocation && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

// Alternative: record? Records automatically define hashCode and == methods based on the structure of their fields.

final goal = MazeLocation(row: 9, col: 9); // defined goal
bool goalTest(MazeLocation ml) => ml == goal;

List<MazeLocation> Function(MazeLocation) successorsForMaze(Maze maze) {
  List<MazeLocation> successors(MazeLocation ml) {
    // no  diagonals
    var newMLs = <MazeLocation>[];

    if (ml.row + 1 < maze.length && maze[ml.row + 1][ml.col] != Cell.blocked) {
      newMLs.add(MazeLocation(row: ml.row + 1, col: ml.col));
    }
    if (ml.row - 1 >= 0 && maze[ml.row - 1][ml.col] != Cell.blocked) {
      newMLs.add(MazeLocation(row: ml.row - 1, col: ml.col));
    }
    if (ml.col + 1 < maze[0].length &&
        maze[ml.row][ml.col + 1] != Cell.blocked) {
      newMLs.add(MazeLocation(row: ml.row, col: ml.col + 1));
    }
    if (ml.col - 1 >= 0 && maze[ml.row][ml.col - 1] != Cell.blocked) {
      newMLs.add(MazeLocation(row: ml.row, col: ml.col - 1));
    }
    return newMLs;
  }

  return successors;
}

class Stack<T> {
  final _container = <T>[];

  bool isEmpty() => _container.isEmpty;

  void push(T thing) {
    _container.add(thing);
  }

  T pop() => _container.removeLast();
}

// node contains all ingredients necessary for the PriorityQueue / A*
class Node<T> implements Comparable<Node<T>> {
  T state;
  Node<T>? parent;
  double cost;
  double heuristic;

  Node({
    required this.state,
    required this.parent,
    this.cost = 0.0,
    this.heuristic = 0.0,
  });

  @override
  int compareTo(Node<T> other) =>
      (cost + heuristic - (other.cost + other.heuristic)).toInt();

  @override
  bool operator ==(Object other) => other is Node && this == other;

  @override
  int get hashCode => (cost + heuristic).toInt();
}

// Depth First Search
Node<ST>? dfs<ST>(
  ST initialState,
  bool Function(ST) goalTestFn,
  List<ST> Function(ST) successorFn,
) {
  final Stack<Node<ST>> frontier = Stack<Node<ST>>();
  frontier.push(Node(state: initialState, parent: null));
  Set<ST> explored = <ST>{};
  explored.add(initialState);
  while (!frontier.isEmpty()) {
    var currentNode = frontier.pop();
    var currentState = currentNode.state;
    if (goalTestFn(currentState)) {
      return currentNode;
    }
    // check where we can go next and haven't explored
    for (var child in successorFn(currentState)) {
      if (!explored.contains(child)) {
        explored.add(child);
        frontier.push(Node(state: child, parent: currentNode));
      }
    }
    // alternative syntax
    // successorFn(currentState).where((child) => !explored.contains(child)).forEach((child) {
    //   explored.add(child);
    //   frontier.push(Node(state: child, parent: currentNode));
    // });
  }
  return null; // never found the goal
}

class Queue<T> {
  final _container = <T>[];

  bool isEmpty() => _container.isEmpty;

  void push(T thing) {
    _container.add(thing);
  }

  T pop() => _container.removeAt(0);
}

// Breadth First Search
// NOTE bfs is exactly dfs with Queue instead of Stack for the frontier
Node<ST>? bfs<ST>(
  ST initialState,
  bool Function(ST) goalTestFn,
  List<ST> Function(ST) successorFn,
) {
  final Queue<Node<ST>> frontier = Queue<Node<ST>>();
  frontier.push(Node(state: initialState, parent: null));

  Set<ST> explored = <ST>{};
  explored.add(initialState);
  while (!frontier.isEmpty()) {
    var currentNode = frontier.pop();
    var currentState = currentNode.state;
    if (goalTestFn(currentState)) {
      return currentNode;
    }
    // check where we can go next and haven't explored
    for (var child in successorFn(currentState)) {
      if (!explored.contains(child)) {
        explored.add(child);
        frontier.push(Node(state: child, parent: currentNode));
      }
    }
    // alternative syntax
    // successorFn(currentState).where((child) => !explored.contains(child)).forEach((child) {
    //   explored.add(child);
    //   frontier.push(Node(state: child, parent: currentNode));
    // });
  }
  return null; // never found the goal
}

List<ST> nodeToPath<ST>(Node<ST> node) {
  List<ST> path = [node.state];
  var lnode = node; // local modifiable copy of the parameter / reference
  // work backwards from end to front
  var currentNode = lnode.parent;
  while (currentNode != null) {
    path.insert(0, currentNode.state);
    lnode = currentNode;
    currentNode = lnode.parent;
  }
  return path;
}

// in Swift: inout Maze
void markMaze(
  Maze maze,
  List<MazeLocation> locationPath,
  MazeLocation start,
  MazeLocation goal,
) {
  for (var ml in locationPath) {
    maze[ml.row][ml.col] = Cell.path; // "P", see above
  }
  maze[start.row][start.col] = Cell.start; // "S"
  maze[goal.row][goal.col] = Cell.goal; // "G"
}

final start = MazeLocation(row: 0, col: 0);

double euclideanDistance(MazeLocation ml) {
  final xdist = ml.col - goal.col;
  final ydist = ml.row - goal.row;
  return math.sqrt((xdist * xdist) + (ydist * ydist));
}

double manhattanDistance(MazeLocation ml) {
  final xdist = (ml.col - goal.col).abs().toDouble();
  final ydist = (ml.row - goal.row).abs().toDouble();
  return xdist + ydist;
}

// A* Search
// simplification: every move in the maze has a cost of 1
Node<ST>? astar<ST>(
  ST initialState,
  bool Function(ST) goalTestFn,
  List<ST> Function(ST) successorFn,
  double Function(ST) heuristicFn,
) {
  // frontier is sorted ascending by f(n) = g(n) + h(n)
  final PriorityQueue<Node<ST>> frontier = PriorityQueue<Node<ST>>();
  frontier.add(
    Node(
      state: initialState,
      parent: null,
      cost: 0,
      heuristic: heuristicFn(initialState),
    ),
  );
  // explored is now a record which records the cost g(n) for each visited node
  Map<ST, double> explored = <ST, double>{};
  explored[initialState] = 0.0;
  while (frontier.isNotEmpty) {
    var currentNode = frontier.removeFirst();
    var currentState = currentNode.state;
    if (goalTestFn(currentState)) {
      return currentNode;
    }
    for (var child in successorFn(currentState)) {
      final newCost = currentNode.cost + 1; // simple cost assumption
      if (explored[child] == null || explored[child]! > newCost) {
        explored[child] = newCost;
        frontier.add(
          Node(
            state: child,
            parent: currentNode,
            cost: newCost,
            heuristic: heuristicFn(child),
          ),
        );
      }
    }
    // alternative syntax
    // successorFn(currentState).where((child) => ...
  }
  return null; // never found the goal
}
