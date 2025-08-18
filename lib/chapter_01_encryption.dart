import 'dart:typed_data';
import 'dart:math' as math;

// using Uint16List instead of Uint8List because Dart Strings consist of 16-bit codeUnits
typedef OTPKey = Uint16List;
typedef OTPKeyPair = ({
  OTPKey key1,
  OTPKey key2,
});

// alternative: implement with Random.secure
// https://api.dart.dev/stable/3.5.0/dart-math/Random/Random.secure.html

OTPKey randomOTPKey({required int length}) {
  var random = math.Random();
  var intList = <int>[];
  for (var n = 0; n < length; n++) {
    intList.add(random.nextInt(65535)); // unsigned 16bit integer 0-65535
  }
  return OTPKey.fromList(intList);
}

OTPKeyPair encryptOTP({required String original}) {
  var length = original.length;
  var dummy = randomOTPKey(length: length);
  OTPKey encrypted = OTPKey(length);
  for (var index = 0; index < length; index++) {
    encrypted[index] = original.codeUnitAt(index) ^ dummy[index]; // XOR
  }
  return (key1: dummy, key2: encrypted);
}

String? decryptOTP({required OTPKeyPair keyPair}) {
  var length = keyPair.key1.length;
  OTPKey decrypted = OTPKey(length);
  for (var index = 0; index < length; index++) {
    decrypted[index] = keyPair.key1[index] ^ keyPair.key2[index]; // XOR
  }
  return String.fromCharCodes(decrypted);
}
