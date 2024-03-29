// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// BASE
//
// By Robert Mollentze / @robmllze (2021)
//
// Please see LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library math_plus;

import 'dart:math';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String getBaseXFromBase10(
  final int num10, [
  final _DigitList digits = DIGITS_BASE_10,
]) {
  final int _digitsLength = digits.digits.length;
  final _digitCount = num10 == 0 ? 0 : log(num10) ~/ log(_digitsLength);
  String _res = "";
  num _next = num10;
  for (num i = _digitCount; i > 0; i--) {
    final num _powL = pow(_digitsLength, i);
    final int _d = _next ~/ _powL;
    _res += digits.digits[_d];
    _next = _next % _powL;
  }
  _res += digits.digits[_next.toInt()];
  return _res;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

int getBase10FromBaseX(
  final String numX, [
  final _DigitList digits = DIGITS_BASE_10,
]) {
  final int _digitsLength = digits.digits.length;
  final int _numXLength = numX.length;
  num _res = 0;
  for (int i = 0; i < _numXLength; i++) {
    final String _c = numX[i];
    if (digits.digits.contains(_c)) {
      final int _index = digits.digits.indexOf(_c);
      final int _x = _numXLength - i - 1;
      _res += _index * pow(_digitsLength, _x);
    } else {
      return -1;
    }
  }
  return _res.toInt();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _DigitList {
  final List<String> digits;
  const _DigitList._(this.digits);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Binary (0-1).
const _DigitList DIGITS_BASE_2 = _DigitList._([
  "0",
  "1",
]);

/// Octal (0-7).
const _DigitList DIGITS_BASE_8 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
]);

/// Decimal (0-9).
const _DigitList DIGITS_BASE_10 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
]);

/// Decimal Reversed (9-0).
const _DigitList DIGITS_BASE_10_REVERSED = _DigitList._([
  "9",
  "8",
  "7",
  "6",
  "5",
  "4",
  "3",
  "2",
  "1",
  "0",
]);

/// Hexadecimal (0-9, A-F).
const _DigitList DIGITS_BASE_16 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
]);

/// Alphabet (A-Z).
const _DigitList DIGITS_BASE_26 = _DigitList._([
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
]);

/// 0-9, A-Z, excluding I, L and O to avoid confusion with 1 and 0.
const _DigitList DIGITS_BASE_33 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  //"I",
  "J",
  "K",
  //"L",
  "M",
  "N",
  //"O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
]);

/// 0-9, A-Z.
const _DigitList DIGITS_BASE_36 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
]);

/// 0-9, A-Z.
const _DigitList DIGITS_BASE_36_SHUFFLED = _DigitList._([
  "Q",
  "9",
  "D",
  "H",
  "T",
  "O",
  "W",
  "5",
  "Y",
  "8",
  "S",
  "X",
  "V",
  "N",
  "K",
  "G",
  "0",
  "R",
  "6",
  "U",
  "B",
  "L",
  "I",
  "E",
  "4",
  "1",
  "J",
  "Z",
  "3",
  "A",
  "7",
  "P",
  "2",
  "M",
  "C",
  "F",
]);

/// 0-9, A-Z, a-z.
const _DigitList DIGITS_BASE_62 = _DigitList._([
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
]);
