import 'package:classic_computer_science/chapter_03_csp.dart';

final class SendMoreMoneyConstraint extends Constraint<String, int> {
  List<String> letters;

  SendMoreMoneyConstraint({required this.letters});

  @override
  List<String> vars() {
    return letters;
  }

  @override
  bool isSatisfied(Map<String, int> assignment) {
    // if there are duplicate values then it's not correct
    final d = assignment.values.toSet();
    if (d.length < assignment.length) {
      return false;
    }

    // if all variables have been assigned, check if it adds up correctly
    if (assignment.length == letters.length) {
      final s = assignment["S"];
      final e = assignment["E"];
      final n = assignment["N"];
      final d = assignment["D"];
      final m = assignment["M"];
      final o = assignment["O"];
      final r = assignment["R"];
      final y = assignment["Y"];
      if (s != null &&
          e != null &&
          n != null &&
          d != null &&
          m != null &&
          o != null &&
          r != null &&
          y != null) {
        var send = s * 1000 + e * 100 + n * 10 + d;
        var more = m * 1000 + o * 100 + r * 10 + e;
        var money = m * 10000 + o * 1000 + n * 100 + e * 10 + y;
        if ((send + more) == money) {
          return true; // answer found
        }
        return false;
      }
    }
    return true;
  }
}
