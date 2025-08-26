import 'package:classic_computer_science/chapter_01_compression.dart'
    as compression;
import 'package:classic_computer_science/chapter_01_encryption.dart'
    as encryption;
import 'package:classic_computer_science/chapter_01_fibonacci.dart'
    as fibonacci;
import 'package:classic_computer_science/chapter_01_hanoi.dart' as hanoi;
import 'package:classic_computer_science/chapter_01_pi.dart' as pi;
import 'package:classic_computer_science/chapter_02_dna.dart' as dna;
import 'package:classic_computer_science/chapter_02_maze.dart' as maze;
import 'package:classic_computer_science/chapter_02_missionaries_cannibals.dart'
    as mc;
import 'package:classic_computer_science/chapter_03_csp.dart' as csp;
import 'package:classic_computer_science/chapter_03_map_coloring.dart' as map;

Map<String, Function> select = {
  "01_fib": chapter01fibonacci,
  "01_hanoi": chapter01hanoi,
  "01_comp": chapter01compression,
  "01_enc": chapter01encryption,
  "01_pi": chapter01pi,
  "02_dna": chapter02dna,
  "02_maze": chapter02maze,
  "02_miss": chapter02missionariesCannibals,
  "03_map": chapter03mapColoringProblem,
};

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.length > 1) {
    print("No example selected. Available examples:");
    select.forEach((key, value) => print(key));
    return;
  } else {
    try {
      select[arguments[0]]!();
    } catch (e) {
      print("Invalid example selected: ${arguments[0]}");
      print("Available examples:");
      select.forEach((key, value) => print(key));
    }
  }
}

void chapter01fibonacci() {
  print('fib2(10): ${fibonacci.fib2(10)}');
  print('fib3(50): ${fibonacci.fib3(50)}');
  print('fib4(50): ${fibonacci.fib4(50)}');
}

void chapter01hanoi() {
  // initialize the first tower

  for (var i = 0; i < hanoi.numDiscs; i++) {
    hanoi.towerA.push(i);
  }

  print("${hanoi.towerA} - ${hanoi.towerB} - ${hanoi.towerC}");

  hanoi.hanoi(
    from: hanoi.towerA,
    to: hanoi.towerC,
    temp: hanoi.towerB,
    n: hanoi.numDiscs,
  );

  print("${hanoi.towerA} - ${hanoi.towerB} - ${hanoi.towerC}");
}

void chapter01compression() {
  print(compression.CompressedGene(original: "ATGAATGCC").decompress());
}

void chapter01encryption() {
  print(
    encryption.decryptOTP(
      keyPair: encryption.encryptOTP(original: "¡Vamos Swift!"),
    ),
  );
}

void chapter01pi() {
  // 3.141592653589793238462643383279502884197169399375105820974944592307816
  // 3.1415916535897743
  print(pi.calculatePi(nTerms: 1000000));
}

void chapter02dna() {
  final gene = dna.stringToGene(dna.geneSequence);

  final acg = (dna.Nucleotide.a, dna.Nucleotide.c, dna.Nucleotide.g);
  print(dna.linearContains(gene, acg));

  dna.Wordlist words = [
    "buck",
    "else",
    "environment",
    "whisper",
    "wash",
    "consciousness",
    "date",
    "survive",
    "wonder",
    "blind",
    "introduce",
    "machine",
    "admit",
    "equipment",
    "encourage",
    "critical",
    "grave",
    "margin",
    "salt",
    "exact",
    "majority",
    "previous",
    "genetic",
    "best",
    "pretty",
    "fairly",
    "stable",
    "break",
    "scope",
    "appear",
    "gear",
    "double",
    "they",
    "tradition",
    "principle",
    "motor",
    "out",
    "budget",
    "step",
    "avoid",
    "from",
    "impose",
    "last",
    "play",
    "partnership",
    "shop",
    "various",
  ];

  words.sort();
  print(dna.binaryContains(words, "budget"));
  print(dna.binaryContains(words, "badget"));
}

void chapter02maze() {
  final aMaze = maze.generateMaze(rows: 10, cols: 10, blockProbability: 0.2);
  print("Maze: ");

  maze.printMaze(aMaze);

  print("Depth-First-Search Solution: ");

  final dfsSolution = maze.dfs(
    maze.start,
    maze.goalTest,
    maze.successorsForMaze(aMaze),
  );

  if (dfsSolution != null) {
    final path = maze.nodeToPath(dfsSolution);
    maze.markMaze(aMaze, path, maze.start, maze.goal);
    maze.printMaze(aMaze);
  } else {
    print("no Depth-First-Search Solution");
  }

  print("Breadth-First-Search Solution: ");

  // bfs uses a copy of the maze because markMaze modifies the maze
  List<List<maze.Cell>> aMazeCopy = List.from(aMaze);

  final bfsSolution = maze.bfs(
    maze.start,
    maze.goalTest,
    maze.successorsForMaze(aMazeCopy),
  );

  if (bfsSolution != null) {
    final path = maze.nodeToPath(bfsSolution);
    maze.markMaze(aMazeCopy, path, maze.start, maze.goal);
    maze.printMaze(aMazeCopy);
  } else {
    print("no Breadth-First-Search Solution");
  }

  print("A* Solution: ");

  // A* uses a copy of the maze because markMaze modifies the maze
  List<List<maze.Cell>> anotherAMazeCopy = List.from(aMaze);

  final astarSolution = maze.astar(
    maze.start,
    maze.goalTest,
    maze.successorsForMaze(anotherAMazeCopy),
    maze.manhattanDistance,
  );

  if (astarSolution != null) {
    final path = maze.nodeToPath(astarSolution);
    maze.markMaze(anotherAMazeCopy, path, maze.start, maze.goal);
    maze.printMaze(anotherAMazeCopy);
  } else {
    print("no A* Solution");
  }
}

void chapter02missionariesCannibals() {
  // at the beginning, everyone is on the western bank
  var startMC = mc.MCState(missionaries: 3, cannibals: 3, boat: true);

  maze.Node<mc.MCState>? solution = maze.bfs(
    startMC,
    startMC.goalTestMC,
    startMC.successorsMC,
  );

  if (solution != null) {
    List<mc.MCState> path = maze.nodeToPath(solution);
    startMC.printMCSolution(path: path);
  } else {
    print("no solution");
  }
}

void chapter03mapColoringProblem() {
  final variables = [
    "Western Australia",
    "Northern Territory",
    "South Australia",
    "Queensland",
    "New South Wales",
    "Victoria",
    "Tasmania",
  ];
  Map<String, List<String>> domains = {};
  for (var variable in variables) {
    domains[variable] = ["r", "g", "b"];
  }
  var mapColoringCsp = csp.CSP<String, String>(variables, domains);
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(
      place1: "Western Australia",
      place2: "Northern Territory",
    ),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(
      place1: "Western Australia",
      place2: "South Australia",
    ),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(
      place1: "South Australia",
      place2: "Northern Territory",
    ),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(
      place1: "Queensland",
      place2: "Northern Territory",
    ),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(place1: "Queensland", place2: "South Australia"),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(place1: "Queensland", place2: "New South Wales"),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(
      place1: "New South Wales",
      place2: "South Australia",
    ),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(place1: "Victoria", place2: "South Australia"),
  );
  mapColoringCsp.addConstraint(
    map.MapColoringConstraint(place1: "Victoria", place2: "New South Wales"),
  );

  final solution = csp.backtrackingSearch(mapColoringCsp);
  if (solution != null) {
    print(solution);
  } else {
    print("Couldn't find solution!");
  }
}
