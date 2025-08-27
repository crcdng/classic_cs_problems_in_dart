// uses the search algorithms implemented in "chapter_02_maze.dart"

class MCState implements Comparable<MCState> {
  final maxNum = 3; // max number of missionaries or cannibals
  late int missionaries; // missionaries on western bank
  late int cannibals; // cannibals on western bank
  late bool boat; // is boat on western bank?

  MCState({
    required this.missionaries,
    required this.cannibals,
    required this.boat,
  });

  @override
  int compareTo(other) {
    // NOTE assumption: maxNum not too large
    return (missionaries -
            other.missionaries +
            1000 * (cannibals - other.cannibals) +
            (boat == other.boat ? 0 : 1000000))
        .toInt();
  }

  @override
  String toString() {
    return "On the western bank there are $missionaries missionaries and $cannibals cannibals.\nOn the eastern bank there are ${maxNum - missionaries} missionaries and ${maxNum - cannibals} cannibals.\nThe boat is on the ${boat ? "western" : "eastern"} bank.\n";
  }

  bool goalTestMC(MCState state) {
    // the western bank is empty -> everyone is on the eastern bank
    return state.missionaries == 0 &&
        state.cannibals == 0 &&
        state.boat == false;
  }

  bool isLegalMC() {
    return (missionaries == 0 || missionaries >= cannibals) && // western bank
        (maxNum - missionaries == 0 || // eastern bank
            (maxNum - missionaries) >= (maxNum - cannibals));
  }

  List<MCState> successorsMC(MCState state) {
    var successors = <MCState>[];
    var wm = state.missionaries; // western bank missionaries
    var wc = state.cannibals; // western bank cannibals
    var em = state.maxNum - wm; // eastern bank missionaries
    var ec = state.maxNum - wc; // eastern bank cannibals
    var b = state.boat;

    if (b) {
      // boat on western bank
      if (wm > 1) {
        successors.add(MCState(missionaries: wm - 2, cannibals: wc, boat: !b));
      }
      if (wm > 0) {
        successors.add(MCState(missionaries: wm - 1, cannibals: wc, boat: !b));
      }
      if (wc > 1) {
        successors.add(MCState(missionaries: wm, cannibals: wc - 2, boat: !b));
      }
      if (wc > 0) {
        successors.add(MCState(missionaries: wm, cannibals: wc - 1, boat: !b));
      }
      if (wc > 0 && wm > 0) {
        successors.add(
          MCState(missionaries: wm - 1, cannibals: wc - 1, boat: !b),
        );
      }
    } else {
      // boat on eastern bank
      if (em > 1) {
        successors.add(MCState(missionaries: wm + 2, cannibals: wc, boat: !b));
      }
      if (em > 0) {
        successors.add(MCState(missionaries: wm + 1, cannibals: wc, boat: !b));
      }
      if (ec > 1) {
        successors.add(MCState(missionaries: wm, cannibals: wc + 2, boat: !b));
      }
      if (ec > 0) {
        successors.add(MCState(missionaries: wm, cannibals: wc + 1, boat: !b));
      }
      if (ec > 0 && em > 0) {
        successors.add(
          MCState(missionaries: wm + 1, cannibals: wc + 1, boat: !b),
        );
      }
    }

    return successors.where((mcstate) => mcstate.isLegalMC()).toList();
  }

  void printMCSolution({required List<MCState> path}) {
    var oldState = path.first;
    print(oldState);
    for (final currentState in path.skip(1)) {
      var wm = currentState.missionaries;
      var wc = currentState.cannibals;
      var em = maxNum - wm;
      var ec = maxNum - wc;
      var b = currentState.boat;

      if (!b) {
        print(
          "${oldState.missionaries - wm} missionaries and ${oldState.cannibals - wc} cannibals moved from the western bank to the eastern bank.",
        );
      } else {
        print(
          "${maxNum - oldState.missionaries - em} missionaries and ${maxNum - oldState.cannibals - ec} cannibals moved from the eastern bank to the western bank.",
        );
      }
      print(currentState);
      oldState = currentState;
    }
  }
}
