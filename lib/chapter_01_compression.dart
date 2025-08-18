import 'package:collection/collection.dart';
// alternative implementation
// https://pub.dev/packages/bit_array

class CompressedGene {
  late int length;
  late BoolList _bitVector;

  CompressedGene({required String original}) {
    length = original.length;
    _bitVector = BoolList(length * 2); // 2 bit per Nucleotide
    compress(gene: original);
  }

  void compress({required String gene}) {
    for (final (index, nucleotide) in gene.split("").indexed) {
      int nStart = index * 2; // start of each new nucleotide
      switch (nucleotide) {
        case "A": // 00
          _bitVector[nStart] = false;
          _bitVector[nStart + 1] = false;
        case "C": // 01
          _bitVector[nStart] = false;
          _bitVector[nStart + 1] = true;
        case "G": // 10
          _bitVector[nStart] = true;
          _bitVector[nStart + 1] = false;
        case "T": // 11
          _bitVector[nStart] = true;
          _bitVector[nStart + 1] = true;
        default:
          throw FormatException("Unexpected character $nucleotide at $index");
      }
    }
  }

  String decompress() {
    String gene = "";

    for (var index = 0; index < length; index++) {
      var nStart = index * 2; // start of each nucleotide
      var firstBit = _bitVector[nStart];
      var secondBit = _bitVector[nStart + 1];

      switch ([firstBit, secondBit]) {
        case ([false, false]): // 00 A
          gene += "A";
        case ([false, true]): // 01 C
          gene += "C";
        case ([true, false]): // 10 G
          gene += "G";
        case ([true, true]): // 11 T
          gene += "T";
        default:
          break; // unreachable, but need default
      }
    }

    return gene;
  }
}
