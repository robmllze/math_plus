import 'dart:convert';
import 'package:math_plus/math_plus.dart';

void main() {
  var v1 = <double>[1, 5, 3].vec2;

  print([1, 2, 3].generate((_value) {
    if (_value != 2) return _value;
    throw false;
  }));
}
