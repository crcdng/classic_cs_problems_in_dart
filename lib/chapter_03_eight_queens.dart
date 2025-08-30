import 'package:classic_computer_science/chapter_03_csp.dart';

final class EightQueensConstraint extends Constraint<int, int> {
  List<int> columns;

  EightQueensConstraint({required this.columns});

  @override
  List<int> vars() {
    return columns;
  }

  @override
  bool isSatisfied(Map<int, int> assignment) {
    // q1c = queen 1 column, q1r = queen 1 row

    // TODO check if there is a more elegant way
    for (MapEntry<int, int> entry in assignment.entries) {
      var q1c = entry.key;
      var q1r = entry.value;
      if (q1c >= vars().length) {
        break;
      }
      for (var q2c = (q1c + 1); q2c <= vars().length; q2c++) {
        // queen 2 column
        var q2r = assignment[q2c];
        if (q2r != null) {
          // queen 2 row
          if (q1r == q2r) {
            return false;
          } // rows same?
          if ((q1r - q2r).abs() == (q1c - q2c).abs()) {
            return false;
          } // same diagonal?
        }
      }
    }
    return true;
  }
}
