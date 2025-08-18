import 'package:collection/collection.dart';

enum Nucleotide implements Comparable<Nucleotide> {
  a(char: "A"),
  c(char: "C"),
  g(char: "G"),
  t(char: "T");

  const Nucleotide({
    required this.char,
  });

  final String char;

  @override
  int compareTo(Nucleotide other) => char.runes.first - other.char.runes.first;
}

// Record
typedef Codon = (Nucleotide, Nucleotide, Nucleotide);
typedef Gene = List<Codon>;

final geneSequence =
    "ACGTGGCTCTCTAACGTACGTACGTACGGGGTTTATATATACCCTAGGACTCCCTTT";

Gene stringToGene(String s) {
  final gene = <Codon>[];
  for (var i = 0; i < s.length; i += 3) {
    if (i + 2 >= s.length) {
      return gene; // skip over incomplete genes
    }
    final n1 = Nucleotide.values.firstWhereOrNull((n) => n.char == s[i]);
    final n2 = Nucleotide.values.firstWhereOrNull((n) => n.char == s[i + 1]);
    final n3 = Nucleotide.values.firstWhereOrNull((n) => n.char == s[i + 2]);
    if (n1 == null || n2 == null || n3 == null) {
      throw ArgumentError("unsopported character in gene sequence");
    } else {
      gene.add((n1, n2, n3));
    }
  }
  return gene;
}

bool linearContains(Gene array, Codon item) {
  return array.contains(item);
}

// binary search on / sorting a gene makes no sense, therefore I use a wordlist for this example
typedef Wordlist = List<String>;

bool binaryContains(Wordlist array, String item) {
  var low = 0;
  var high = array.length - 1;
  while (low <= high) {
    var mid = (low + high) ~/ 2; // truncating division
    if (array[mid].compareTo(item) < 0) {
      low = mid + 1;
    } else if (array[mid].compareTo(item) > 0) {
      high = mid - 1;
    } else {
      return true;
    }
  }
  return false;
}
