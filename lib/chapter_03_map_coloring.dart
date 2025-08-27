import 'package:classic_computer_science/chapter_03_csp.dart';

final class MapColoringConstraint extends Constraint<String, String> {
  String place1;
  String place2;

  MapColoringConstraint({required this.place1, required this.place2});

  @override
  List<String> vars() {
    return [place1, place2];
  }

  @override
  bool isSatisfied(Map<String, String> assignment) {
    // if one or both variables don't have domain values assigned, the constraint is "trivially" satisfied
    if (assignment[place1] == null || assignment[place2] == null) {
      return true;
    }
    return assignment[place1] != assignment[place2];
  }
}
