import 'dart:math';

import 'package:classic_computer_science/chapter_03_csp.dart';
import 'package:collection/collection.dart';

typedef Character = String;

typedef Grid = List<List<Character>>;

class GridLocation {
  int row;
  int col;

  GridLocation(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is GridLocation && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

Grid generateGrid({required int rows, required int columns}) {
  final grid = List.generate(rows, (_) => List.generate(columns, (_) => " "));

  for (var row = 0; row < rows; row++) {
    for (var col = 0; col < columns; col++) {
      var loc = Random().nextInt(alphabet.length);
      grid[row][col] = alphabet[loc];
    }
  }

  return grid;
}

void printGrid(Grid grid) {
  for (var i = 0; i < grid.length; i++) {
    print(grid[i]);
  }
}

List<List<GridLocation>> generateDomain(String word, Grid grid) {
  // NOTE if set to [[]] the inner empty list entry leads to failure
  List<List<GridLocation>> domain = [];
  final height = grid.length;
  final width = grid[0].length;
  final wordLength = word.length;

  for (var row = 0; row < height; row++) {
    for (var col = 0; col < width; col++) {
      var columns = List.generate(wordLength + 1, (i) => i + col);
      var rows = List.generate(wordLength + 1, (i) => i + row);

      if (col + wordLength <= width) {
        // left to right
        domain.add(columns.map((c) => GridLocation(row, c)).toList());
        // diagonal towards bottom right
        if (row + wordLength <= height) {
          domain.add(
            rows.map((r) => GridLocation(r, col + (r - row))).toList(),
          );
        }
      }
      if (row + wordLength <= height) {
        // top to bottom
        domain.add(rows.map((r) => GridLocation(r, col)).toList());
        // diagonal towards bottom left
        if (col - wordLength >= 0) {
          domain.add(
            rows.map((r) => GridLocation(r, col - (r - row))).toList(),
          );
        }
      }
    }
  }
  return domain;
}

final class WordSearchConstraint
    extends Constraint<String, List<GridLocation>> {
  List<String> words;

  WordSearchConstraint({required this.words});

  @override
  List<String> vars() {
    return words;
  }

  // fail if words overlap
  @override
  bool isSatisfied(Map<String, List<GridLocation>> assignment) {
    if (assignment.values.flattened.toSet().length <
        assignment.values.flattened.length) {
      return false;
    }
    return true;
  }
}
