class CSP<V extends Object, D> {
  // extending Object implies V cannot be null and V has a hash
  List<V> variables;
  // mapping a variable to a list of possible values
  Map<V, List<D>> domains;
  // mapping a variable to a list of constraints
  late Map<V, List<Constraint<V, D>>> constraints;

  CSP({required this.variables, required this.domains}) {
    constraints = <V, List<Constraint<V, D>>>{};
    for (final variable in variables) {
      constraints[variable] = <Constraint<V, D>>[];
      if (domains[variable] == null) {
        print("Error: Missing domain for variable $variable.");
      }
    }
  }

  void addConstraint(Constraint<V, D> constraint) {
    // constraint.vars is a method
    for (final variable in constraint.vars()) {
      if (!variables.contains(variable)) {
        print(
          "Error: Could not find variable $variable from constraint $constraint in CSP.",
        );
      }
      constraints[variable]?.add(constraint);
    }
  }
}

// NOTE making this class abstract avoids subtle errors by not implementing a method in a subclass
abstract class Constraint<V, D> {
  List<V> vars();
  bool isSatisfied(Map<V, D> assignment);
}

Map<V, D>? backtrackingSearch<V extends Object, D>(
  CSP<V, D> csp, [
  Map<V, D>? assignment,
]) {
  assignment ??= {}; // NOTE non-constant default value
  // assignment is complete if it has as many assignments as there are variables
  if (assignment.length == csp.variables.length) {
    return assignment;
  } // base case

  // what are the unassigned variables?
  var unassigned = csp.variables.where((v) => assignment?[v] == null);
  // get the domain of the first unassigned variable
  V variable;
  List<D>? domain;

  try {
    variable = unassigned.first;
  } catch (e) {
    return null;
  }

  domain = csp.domains[variable];

  if (domain != null) {
    for (final value in domain) {
      // NOTE in Dart a copy is required instead of an assignment
      var localAssignment = Map<V, D>.from(assignment);
      localAssignment[variable] = value;
      // if the value is consistent with the current assignment we continue
      if (isConsistent(variable, value, localAssignment, csp)) {
        // if as we go down the tree we get a complete assignment, return it
        var result = backtrackingSearch(csp, localAssignment);
        if (result != null) {
          return result;
        }
      }
    }
  }

  return null; // no solution
}

/// check if the value assignment is consistent by checking all constraints of the variable
bool isConsistent<V extends Object, D>(
  V variable,
  D value,
  Map<V, D> assignment,
  CSP<V, D> csp,
) {
  for (final constraint in csp.constraints[variable] ?? []) {
    if (!(constraint.isSatisfied(assignment) as bool)) {
      /// TODO check why bool is not inferred
      return false;
    }
  }
  return true;
}
