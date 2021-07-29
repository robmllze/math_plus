// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// MISC
//
// By Robert Mollentze / @robmllze (2021)
//
// Please see LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library math_plus;

import 'dart:math' show Random;

import 'base.dart';
import 'int_convert.dart';
import 'mapping.dart' show mapShuffle, unmapShuffle;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum CryptMethod { BASIC, PSEUDO, NONE }

//
//
//

extension CryptMethodCode on CryptMethod {
  int get code {
    switch (this) {
      case CryptMethod.BASIC:
        return 0;
      case CryptMethod.PSEUDO:
        return 1;
      default:
        return -1;
    }
  }
}

//
//
//

CryptMethod codeToEncryptionMethod(final int code) {
  switch (code) {
    case 0:
      return CryptMethod.BASIC;
    case 1:
      return CryptMethod.PSEUDO;
    default:
      return CryptMethod.NONE;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Used to verify decryption success.
const String _OK = "0|<@Y";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension Crypt on String {
  //
  //
  //

  String encryptedBasic(final String password) {
    final List<int> _password = password.codeUnits;
    final List<int> _encrypted = [];
    int _temp;
    int _i = 0;
    for (final int c in "$_OK$this".codeUnits) {
      _temp = c + _i + _password[_i++];
      if (_i == _password.length) {
        _i = 0;
      }
      while (_temp > 255) {
        _temp -= 255;
      }
      _encrypted.add(_temp);
    }
    return CryptMethod.BASIC.code.toBytesFromUint32 +
        String.fromCharCodes(_encrypted);
  }

  //
  //
  //

  String? decryptedBasic(final String password) {
    if (this.length >= 4 && this.toUint32FromBytes == CryptMethod.BASIC.code) {
      final List<int> _password = password.codeUnits;
      final List<int> _codes = [];
      int _temp;
      int _i = 0;
      for (final int c in this.substring(4).codeUnits) {
        _temp = c - _i - _password[_i++];
        if (_i == _password.length) {
          _i = 0;
        }
        while (_temp < 0) {
          _temp += 255;
        }
        _codes.add(_temp);
      }
      final String _decrypted = String.fromCharCodes(_codes);
      if (_decrypted.startsWith(_OK)) {
        return _decrypted.substring(_OK.length);
      }
    }
    return null;
  }

  //
  //
  //

  /// Adds arbitrary pseudo data to message before encrypting.
  String encryptedPseudo(
    final String password, [
    final int pseudoLengthMin = 4,
    final int pseudoLengthMax = 12,
  ]) {
    assert(pseudoLengthMin >= 0);
    assert(pseudoLengthMax >= 0);
    final Random _random = Random();
    final int _pseudoLength = pseudoLengthMin +
        (pseudoLengthMax != 0 ? _random.nextInt(pseudoLengthMax) : 0);
    final String _pseudoLengthAsBytes = _pseudoLength.toBytesFromUint32;
    final List<int> _charCodesPseudo =
        List<int>.generate(_pseudoLength, (_) => _random.nextInt(256));
    final String _pseudo = String.fromCharCodes(_charCodesPseudo);
    // If message starts with \0\0\0\0, the first 4 characters of the password
    // will be visible. Adding #### before the password hides it.
    return CryptMethod.PSEUDO.code.toBytesFromUint32 +
        ("$_pseudoLengthAsBytes"
                "$_pseudo"
                "$_OK"
                "$this")
            .encryptedBasic("####$password");
  }

  //
  //
  //

  String? decryptedPseudo(
    final String password, [
    final int pseudoLengthMax = 1024,
  ]) {
    assert(pseudoLengthMax >= 0);
    if (this.length >= 4 && this.toUint32FromBytes == CryptMethod.PSEUDO.code) {
      final String? _basic = this.substring(4).decryptedBasic("####$password");
      if (_basic != null) {
        final int _pseudoLength = _basic.toUint32FromBytes ?? 0;
        if (_pseudoLength > pseudoLengthMax) return "";
        final int _start = 4 + _pseudoLength;
        final String? _res =
            _basic.length >= _start ? _basic.substring(_start) : null;
        if (_res != null && _res.startsWith(_OK)) {
          return _res.substring(_OK.length);
        }
      }
    }
    return null;
  }

  //
  //
  //

  String? decrypted(final String password) {
    if (this.length >= 4) {
      final int? _code = this.toUint32FromBytes;
      if (_code != null) {
        final CryptMethod? _method = codeToEncryptionMethod(_code);
        switch (_method) {
          case CryptMethod.BASIC:
            return this.decryptedBasic(password);
          case CryptMethod.PSEUDO:
            return this.decryptedPseudo(password);
          default:
            return null;
        }
      }
    }
    return null;
  }

  //
  //
  //

  String shuffled([final int shuffle = 3]) {
    final int _length = this.length;
    final List<int> _charCodes = this.codeUnits;
    final List<int> _shuffledPositions = [];
    for (int n = 0; n < _length; n++) {
      _shuffledPositions.add(mapShuffle(n, _length - 1, shuffle));
    }
    final List<int> _shuffled = List<int>.generate(
        this.length, (__i) => _charCodes[_shuffledPositions[__i]]);
    return String.fromCharCodes(_shuffled);
  }

  //
  //
  //

  String unshuffled([final int shuffle = 3]) {
    final int _length = this.length;
    final List<int> _charCodes = this.codeUnits;
    final List<int> _unshuffledPositions = [];
    for (int n = 0; n < _length; n++) {
      _unshuffledPositions.add(unmapShuffle(n, _length - 1, shuffle));
    }
    final List<int> _unshuffled = List<int>.generate(
        this.length, (__i) => _charCodes[_unshuffledPositions[__i]]);
    return String.fromCharCodes(_unshuffled);
  }

  //
  //
  //

  String encodedLength() {
    return this.length.toBytesFromUint32 + this;
  }

  //
  //
  //

  String decodedLength([final int? lengthMax]) {
    final int? _length = this.toUint32FromBytes;
    if (_length != null &&
        _length <= this.length - 4 &&
        (lengthMax == null || _length <= lengthMax)) {
      return this.substring(4, 4 + _length);
    }
    return this;
  }

  //
  //
  //

  List<String> lengthSplit() {
    List<String> _res = [];
    int n = 0;
    while (true) {
      final String _temp = this.substring(n).decodedLength();
      _res.add(_temp);
      n += 4 + _temp.length;
      if (n >= this.length) {
        break;
      }
    }
    return _res;
  }

  //
  //
  //

  String stripified() {
    return this.codeUnits.join("-");
  }

  //
  //
  //

  String unstripified() {
    List<int> _charCodes = [];
    for (final String el in this.split("-")) {
      final int? _c = int.tryParse(el);
      if (_c == null) return "";
      _charCodes.add(_c);
    }
    return String.fromCharCodes(_charCodes);
  }

  //
  //
  //

  String codified([final int shuffle = 3]) {
    final List<int> _codeUnits = this.codeUnits;
    final List<String> _res = [];
    for (final int el in _codeUnits) {
      final String _u = getBaseXFromBase10(el, DIGITS_BASE_36_SHUFFLED);
      if (_u.length == 1) {
        final int _code = Random.secure().nextInt(26);
        final String _prefix = String.fromCharCode(97 /*'a'*/ + _code);
        _res.add("$_prefix$_u");
      } else {
        _res.add(_u);
      }
    }
    return _res.join().shuffled(shuffle);
  }

  //
  //
  //

  String? uncodified([final int shuffle = 3]) {
    final String _unshuffled = this.unshuffled(shuffle);
    final List<int> _res = [];
    for (int n = 0; n < _unshuffled.length; n += 2) {
      int? _c;
      final int _code = _unshuffled[n].codeUnitAt(0);
      if (_code >= 97 /*'a'*/ && _code <= 122 /*'z'*/) {
        _c = getBase10FromBaseX(_unshuffled[n + 1], DIGITS_BASE_36_SHUFFLED);
      } else {
        _c = getBase10FromBaseX(
            _unshuffled[n] + _unshuffled[n + 1], DIGITS_BASE_36_SHUFFLED);
      }
      if (_c == -1) return null;
      _res.add(_c);
    }
    return String.fromCharCodes(_res);
  }

  //
  //
  //

  String reversed() {
    return this.split("").reversed.join("");
  }

  //
  //
  //
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String lengthJoin(final List<String> elements) {
  String _res = "";
  for (final String el in elements) {
    _res += el.encodedLength();
  }
  return _res;
}
