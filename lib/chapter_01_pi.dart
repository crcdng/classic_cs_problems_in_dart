double calculatePi({required int nTerms}) {
  var numerator = 4.0;
  var denominator = 1.0;
  var operation = -1.0;
  var pi = 0.0;
  for (var n = 0; n < nTerms; n++) {
    pi += operation * (numerator / denominator);
    denominator += 2.0;
    operation *= -1.0;
  }
  return pi.abs();
}
