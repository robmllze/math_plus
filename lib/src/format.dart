// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// FORMAT
//
// By Robert Mollentze / @robmllze (2021)
//
// Please see LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library math_plus;

import 'dart:math';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// ROUNDING AND TRUNCATING
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

double log10(num x) => log(x) / ln10;

double rountToFigure(final double x, final int figures) {
  if (x == 0) return 0;
  final double a = log10(x).truncateToDouble();
  final num y = pow(10, a + 1 - figures);
  return y * (x / y).roundToDouble();
}

double truncToFigure(final double x, final int figures) {
  if (x == 0) return 0;
  final double a = log10(x).truncateToDouble();
  final num y = pow(10, a + 1 - figures);
  return y * (x / y).truncateToDouble();
}

double roundAt(final double x, final int figures) {
  if (x == 0) return 0;
  final double y = pow(10, figures).toDouble();
  return (x * y).roundToDouble() / y;
}

double truncateAt(final double x, final int figures) {
  if (x == 0) return 0;
  final double y = pow(10, figures).toDouble();
  return (x * y).truncateToDouble() / y;
}
