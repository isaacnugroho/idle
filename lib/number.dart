import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
class Number implements Comparable<Number> {
  final double mantissa;
  final double exponent;

  const Number._({required this.mantissa, required this.exponent});

  factory Number.from(num numValue) {
    return normalize(numValue.toDouble(), 0.0);
  }

  factory Number.number(num m, num e) {
    return normalize(m.toDouble(), e.toDouble());
  }

  static const Number zero = Number._(mantissa: 0.0, exponent: 0);
  static const Number one = Number._(mantissa: 1.0, exponent: 0);
  static const Number two = Number._(mantissa: 2.0, exponent: 0);
  static const Number ten = Number._(mantissa: 1.0, exponent: 1);

  bool isZero() {
    return mantissa == 0.0;
  }

  bool isOne() {
    return mantissa == 1.0 && exponent == 0;
  }

  bool isNegative() {
    return mantissa < 0.0;
  }

  bool isNonNegative() {
    return mantissa >= 0.0;
  }

  @override
  String toString() {
    if (exponent > -2 && exponent < 6) {
      var value = (mantissa * pow(10, exponent + 2)).roundToDouble() * 0.01;
      return value.toStringAsFixed(2);
    }
    return "${mantissa.toStringAsFixed(2)}e${exponent.toInt()}";
  }

  // String toStringAsFixed(int decimals) {
  //   assert(decimals >= 0);
  //   return '${mantissa.toStringAsFixed(decimals)}e${exponent.toInt()}';
  // }

  Number operator *(Number number) => mul(number);

  Number operator /(Number number) => div(number);

  Number operator +(Number number) => add(number);

  Number operator -(Number number) => sub(number);

  Number operator -() => negate();

  bool operator <(Number number) => compareTo(number) == -1;

  bool operator >(Number number) => compareTo(number) == 1;

  bool operator <=(Number number) => compareTo(number) != 1;

  bool operator >=(Number number) => compareTo(number) != -1;

  Number log10() {
    if (isNegative() || isZero()) {
      throw UnsupportedError("log of negative or zero");
    }
    if (isOne()) {
      return Number.zero;
    }
    if (mantissa == 1.0) {
      return normalize(exponent, 0.0);
    }
    return normalize(exponent + log(mantissa) / ln10, 0.0);
  }

  Number power(Number number) {
    if (isNegative()) {
      throw UnsupportedError("power of negative number");
    }
    if (isZero()) {
      return Number.zero;
    }
    if (isOne() || number.isZero()) {
      return Number.one;
    }

    var mb = number.mantissa * exponent;
    var mb1 = mb.truncateToDouble();
    var mb2 = mb - mb1;
    var powB = pow(10.0, number.exponent) as double;
    var aToB = pow(mantissa, number.mantissa) as double;
    var manAB = pow(aToB * pow(10.0, mb2), powB) as double;
    var expAB = mb1 * powB;
    return normalize(manAB, expAB);
  }

  Number mul(Number number) {
    if (isZero() || number.isZero()) {
      return Number.zero;
    }
    var result = mantissa * number.mantissa;
    return normalize(result, exponent + number.exponent);
  }

  Number div(Number number) {
    if (number.isZero()) {
      throw UnsupportedError("divide by zero");
    }
    if (isZero()) {
      return Number.zero;
    }
    var result = mantissa / number.mantissa;
    return normalize(result, exponent - number.exponent);
  }

  Number add(Number number) {
    if (isZero()) {
      return number;
    }
    if (number.isZero()) {
      return this;
    }
    var expDelta = exponent - number.exponent;
    if (expDelta == 0) {
      var addition = mantissa + number.mantissa;
      return normalize(addition, exponent);
    }
    if (expDelta < 0) {
      if (expDelta <= -308) {
        return number;
      }
      var addition = mantissa * pow(10, expDelta) + number.mantissa;
      return normalize(addition, number.exponent);
    }
    if (expDelta >= 308) {
      return this;
    }
    var addition = mantissa + number.mantissa * pow(10, -expDelta);
    return normalize(addition, exponent);
  }

  Number sub(Number number) {
    if (isZero()) {
      return number.negate();
    }
    if (number.isZero()) {
      return this;
    }
    var expDelta = exponent - number.exponent;
    if (expDelta == 0) {
      var subtraction = mantissa - number.mantissa;
      return normalize(subtraction, exponent);
    }
    if (expDelta < 0) {
      if (expDelta <= -308) {
        return number.negate();
      }
      var subtraction = mantissa * pow(10, expDelta) - number.mantissa;
      return normalize(subtraction, number.exponent);
    }
    if (expDelta >= 308) {
      return this;
    }
    var subtraction = mantissa - number.mantissa * pow(10, -expDelta);
    return normalize(subtraction, exponent);
  }

  Number negate() {
    return Number._(mantissa: -mantissa, exponent: exponent);
  }

  bool equals(Number other) {
    return exponent == other.exponent && mantissa == other.mantissa;
  }

  int get sign {
    return mantissa.sign.toInt();
  }

  @override
  int compareTo(Number number) {
    var thisSign = mantissa.sign.toInt();
    var thatSign = number.sign;
    if (thisSign < thatSign) {
      return -1;
    }
    if (thisSign > thatSign) {
      return 1;
    }
    if (exponent == number.exponent) {
      if (mantissa == number.mantissa) {
        return 0;
      }
      if (mantissa < number.mantissa) {
        return -1;
      }
      return 1;
    }
    if (exponent < number.exponent) {
      return -thisSign;
    }
    return thisSign;
  }

  static Number normalize(double value, double exp) {
    var valueSign = value.sign;
    if (valueSign == 0) {
      return Number.zero;
    }
    double norm;
    if (valueSign > 0) {
      norm = value;
    } else {
      norm = -value;
    }
    if (norm < 1.0) {
      while (norm < 1.0) {
        norm = norm * 10.0;
        value = value * 10.0;
        exp = exp - 1.0;
      }
    } else {
      while (norm >= 10.0) {
        norm = norm / 10.0;
        value = value / 10.0;
        exp = exp + 1.0;
      }
    }
    return Number._(mantissa: value, exponent: exp);
  }
}
